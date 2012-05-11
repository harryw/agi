class Deployment < ActiveRecord::Base
    
    belongs_to :app
    belongs_to :user
    
    delegate :chef_account_update_data_bag_item, :lb_dns, :dynect_cname_status, :dynect_cname_name, :to => :app, :prefix => true
        
    serialize :deployed_data
    
    # :update_databag will be moved to an asyncronous state later
    before_save :set_initial_status, :save_deployed_data, :update_databag, :save_iq_file, :cname_load_balancer

    attr_accessible :git_repo, :git_commit, :send_email, :task, :run_migrations, :migration_command, :app_id, :deployment_timestamp, :deployed_data, :force_deploy, :final_result, :opscode_result, :opscode_log, :description, :user_id, :s3_url_iq, :deployed_time
        
    #### IQ generation
      
    def save_iq_file
      pdf = IqDeployment.new(self,deploying_time)
      pdf_file_content = pdf.render
      
      begin
        s3.get_bucket(iq_bucket) rescue s3.put_bucket(iq_bucket)
        s3.directories.get(iq_bucket).files.create(:key => s3_key_name, :body=> pdf_file_content)
      rescue => e
        error=""
        if match = e.message.match(/<Code>(.*)<\/Code>[\s\\\w]*<Message>(.*)<\/Message>/m)
          error="#{match[1].split('.').last} => #{match[2]}"
        else
          error=e.message
        end
        Rails.logger.info "S3 FAILURE - #{e.message}"
        self.errors.add(:remote_connection_to_s3, "it failed to save the IQ file in S3, #{error}")
        return false
      end
    end
    
    def s3
      @s3 ||= Fog::Storage::AWS.new(:aws_access_key_id => AppConfig["amazon_s3"]["access_key_id"], 
                                    :aws_secret_access_key => AppConfig["amazon_s3"]["secret_access_key"])
    end
    
    def s3_key_name
      iq_folder = AppConfig["amazon_s3"]["bucket_name"].split('/')[1..-1].join('/')
      @s3_key_name ||= "#{iq_folder}/#{app.name}/#{app.name}-#{deploying_time.to_s(:number)}.pdf".gsub(/^\//,"")
    end
    
    def iq_bucket
      AppConfig["amazon_s3"]["bucket_name"].split('/').first
    end
    
    def deploying_time
      @deploying_time ||= Time.now
    end
    
    def gen_s3_url_iq
      "https://#{iq_bucket}.s3.amazonaws.com/#{s3_key_name}"
    end
    
    ######################
    
    
    def set_initial_status
      self.started_at = Time.now
      self.final_result = 'Pending'
      self.description = app.name if description.blank?
      self.app_name = app.name
    end
    
    def save_deployed_data
      self.git_repo = app.project.repository
      self.git_commit = app.git_revision
      self.deployed_data = merged_configuration
      self.s3_url_iq = gen_s3_url_iq
      self.deployed_time = deploying_time
    end
   
    def update_databag
      begin
        app_chef_account_update_data_bag_item(merged_configuration)
        self.final_result = 'Success'
        self.opscode_log= 'OK'
      rescue 
        self.opscode_log= $!.message 
        self.final_result = 'Failed'  
      end
      self.completed_at = Time.now  # self is required for assignments
    end
    
    def configuration
      attributes.symbolize_keys.extract!(:force_deploy,:send_email,:task,:run_migrations,
                                                  :migration_command,:deployment_timestamp).merge(:deploy_by => self.user.email, :deployed_at => deploying_time)
    end
    
    def merged_configuration
      conf = app.generate_deployment_data
      conf[:main].merge!(configuration)
      conf
    end
    
    private
      
      def cname_load_balancer
        if app_lb_dns and app_dynect_cname_name
          unless cname_record = Dynect.find(app_dynect_cname_name) rescue nil
            begin
              debugger
              new_dynect_cname = Dynect.new("zone"=> AppConfig["agifog"]["dynectzone"],
                                          "ttl"=> 600,
                                          "fqdn" => app_dynect_cname_name,
                                          "record_type" => "CNAME",
                                          "rdata"=> app_lb_dns)
              if new_dynect_cname.save
                self.dynect_cname_log = "OK: #{app_dynect_cname_name} CNAME was created successfully"
              else
                self.dynect_cname_log = "Error: #{new_dynect_cname.errors.full_messages.join(' ')}"
                #self.errors.add(:creating_dynect_cname_record, "Error: it failed to create it")
                #return false
              end
            rescue
              self.dynect_cname_log = "failed to create it: #{$!.message}"
              #self.errors.add(:creating_dynect_cname_record, "Error: it failed to create it")
              #return false
            end
          else
            if !cname_record.rdata or !cname_record.rdata.cname 
              self.dynect_cname_log = "ERROR:#{app_dynect_cname_name} CNAME was already created, but we couldn't retrieve where it points to"
            elsif cname_record.rdata.cname.gsub(/\.$/,'') == app_lb_dns
              self.dynect_cname_log = "OK: #{app_dynect_cname_name} CNAME was already created"
            else
              self.dynect_cname_log = "ERROR: #{app_dynect_cname_name} CNAME was already created, but belongs to a different ELB hostname: #{cname_record.rdata.cname.gsub(/\.$/,'')} instead of #{app_lb_dns}"
            end
          end
        end
      end
    
end
