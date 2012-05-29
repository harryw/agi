class Deployment < ActiveRecord::Base
    
    belongs_to :app
    belongs_to :user
    
    delegate :chef_account_update_data_bag_item, :lb_dns, :dynect_cname_status, :dynect_cname_name, :ec2_sg_to_authorize, :to => :app, :prefix => true
        
    serialize :deployed_data
    
    before_save :set_initial_status, :save_deployed_data, :save_iq_file, :update_databag, :cname_load_balancer

    attr_accessible :git_repo, :git_commit, :send_email, :task, :run_migrations, :migration_command, :app_id, :deployment_timestamp, 
    :deployed_data, :force_deploy, :final_result, :opscode_result, :opscode_log, :description, :user_id, :s3_url_iq, :deployed_time,
    :merge_iq_with_medistrano_pir
        
    def get_medistrano_pir!
      pir = PirDeployment.new(self)
      pir.get_medistrano_pir!
    end

    def save_iq_file
      if Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable
        pdf_file_raw = merge_iq_with_medistrano_pir ? merge_pir_with_iq : generate_iq_file
      else
        pdf_file_raw = generate_iq_file
      end

      begin
        S3Storage.store(iq_bucket, iq_file, pdf_file_raw)
      rescue => e
        raise("Failed to save the IQ file in S3, #{e.message}")
      end
    end
    
    def deploying_time
      @deploying_time ||= Time.now
    end

    private

    ####################################################################################################################################
    # before_save hooks
    ####################################################################################################################################

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

    def cname_load_balancer
      if app_lb_dns and app_dynect_cname_name
        unless cname_record = Dynect.find(app_dynect_cname_name) rescue nil
          begin
            new_dynect_cname = Dynect.new("zone"=> AppConfig["agifog"]["dynectzone"],
                                        "ttl"=> 600,
                                        "fqdn" => app_dynect_cname_name,
                                        "record_type" => "CNAME",
                                        "rdata"=> app_lb_dns)
            self.dynect_cname_log = if new_dynect_cname.save
                                      "OK: #{app_dynect_cname_name} CNAME was created successfully"
                                    else
                                      "Error: #{new_dynect_cname.errors.full_messages.join(' ')}"
                                    end
          rescue
            self.dynect_cname_log = "failed to create it: #{$!.message}"
          end
        else
          self.dynect_cname_log = if !cname_record.rdata or !cname_record.rdata.cname
                                    "ERROR:#{app_dynect_cname_name} CNAME was already created, but we couldn't retrieve where it points to"
                                  elsif cname_record.rdata.cname.gsub(/\.$/,'') == app_lb_dns
                                    "OK: #{app_dynect_cname_name} CNAME was already created"
                                  else
                                    "ERROR: #{app_dynect_cname_name} CNAME was already created, but belongs to a different ELB hostname: #{cname_record.rdata.cname.gsub(/\.$/,'')} instead of #{app_lb_dns}"
                                  end
        end
      end
    end


      def generate_iq_file
        pdf = IqDeployment.new(deployed_data,deploying_time)
        pdf.render
      end
      
      ####################################################################################################################################
      # S3 Storage
      ####################################################################################################################################
          
    def iq_file
      iq_folder = S3Storage.config["bucket_name"].split('/')[1..-1].join('/')
      @s3_key_name ||= "#{iq_folder}/#{app.name}/#{app.name}-#{deploying_time.to_s(:number)}.pdf".gsub(/^\//,"")
    end

    def iq_bucket
      S3Storage.config["bucket_name"].split('/').first
    end

      ####################################################################################################################################
      # Deploy Configuration
      ####################################################################################################################################

      def configuration
        attributes.symbolize_keys.extract!(:force_deploy,:send_email,:task,:run_migrations,
                                                    :migration_command,:deployment_timestamp).merge(:deploy_by => self.try(:user).try(:email), :deployed_at => deploying_time)
      end
      
      def merged_configuration
        conf = app.generate_deployment_data
        conf[:main].merge!(configuration)
        conf
      end
      
      ####################################################################################################################################
      # Medistrano PIR
      ####################################################################################################################################
      

      def merge_pir_with_iq
        pir = PirDeployment.new(self)
        pir.merge_pir_with_iq
      end
      
      ####################################################################################################################################    
end
