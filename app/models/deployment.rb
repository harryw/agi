class Deployment < ActiveRecord::Base
    
    belongs_to :app
    belongs_to :user
    
    delegate :chef_account_update_data_bag_item, :lb_dns, :dynect_cname_status, :dynect_cname_name, :ec2_sg_to_authorize, :to => :app, :prefix => true
        
    serialize :deployed_data
    
    before_save :set_initial_status, :save_deployed_data, :save_iq_file, :update_databag, :cname_load_balancer

    attr_accessible :git_repo, :git_commit, :send_email, :task, :run_migrations, :migration_command, :app_id, :deployment_timestamp, 
    :deployed_data, :force_deploy, :final_result, :opscode_result, :opscode_log, :description, :user_id, :s3_url_iq, :deployed_time,
    :merge_iq_with_medistrano_pir
        
    def get_medistrano_pir
      begin
        s3.get_bucket(medistrano_pir_bucket_name)
        if medistrano_pir_handler = s3.directories.get(medistrano_pir_bucket_name).files.get(medistrano_pir_key_name)
          @medistrano_pir = medistrano_pir_handler.body
        else
          raise "doesn't exist. Go to Medistrano and generate the PIR "
        end
      rescue => e          
        raise "#{medistrano_pir_bucket_name}/#{medistrano_pir_key_name} #{try_to_parse_excon_aws_error(e)}"
      end
      @medistrano_pir                    
    end

    private
    
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
      
      def save_iq_file
        if Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable
          pdf_file_raw = merge_iq_with_medistrano_pir ? merge_pir_with_iq : generate_iq_file
        else
          pdf_file_raw = generate_iq_file
        end
        upload_to_s3(pdf_file_raw)
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
        pdf = IqDeployment.new(self,deploying_time)
        pdf.render
      end
      
      ####################################################################################################################################
      # S3 
      ####################################################################################################################################
          
      def gen_s3_url_iq
        "https://#{iq_bucket}.s3.amazonaws.com/#{s3_key_name}"
      end
                  
      def upload_to_s3(pdf_file_content)
        begin
          s3.get_bucket(iq_bucket) rescue s3.put_bucket(iq_bucket)
          s3.directories.get(iq_bucket).files.create(:key => s3_key_name, :body=> pdf_file_content)
        rescue => e
          raise("it failed to save the IQ file in S3, #{try_to_parse_excon_aws_error(e)}")
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
      
      
      ####################################################################################################################################
      # Deploy Configuration
      ####################################################################################################################################
      def deploying_time
        @deploying_time ||= Time.now
      end
      
      
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
      # Util
      ####################################################################################################################################
    
      def try_to_parse_excon_aws_error(rescue_error_msg)
        if match = rescue_error_msg.message.match(/<Code>(.*)<\/Code>[\s\\\w]*<Message>(.*)<\/Message>/m)
          "#{match[1].split('.').last} => #{match[2]}"
        else
          rescue_error_msg.message
        end
      end
      
      ####################################################################################################################################
      # Medistrano PIR
      ####################################################################################################################################
      
      def medistrano_pir_bucket_name
        "columbo-portal-current"
      end
      
      def medistrano_pir_key_name
        raise "ec2_sg_to_authorize isn't set, Agi can't determine the medistrano project and stage" if app_ec2_sg_to_authorize.blank?
        medistrano_project, medistrano_stage, medistrano_cloud = app_ec2_sg_to_authorize.split(/-/)
        "#{medistrano_project}/IQ/#{medistrano_project}-#{medistrano_stage}-PIR.pdf"
      end
      
      def save_medistrano_pir
        @pir_file = Tempfile.open(['medistrano-pir','.pdf'], Rails.root.join('tmp'), :encoding => 'ascii-8bit' )
        @pir_file.write get_medistrano_pir
        @pir_file.close
        @pir_file.path
      end
      
      def save_agi_iq
        @iq_file = Tempfile.open(['agiapp-iq','.pdf'], Rails.root.join('tmp'), :encoding => 'ascii-8bit' )
        @iq_file.write generate_iq_file
        @iq_file.close
        @iq_file.path
      end

      def merge_pir_with_iq
        @pdftk = ActivePdftk::Wrapper.new
        @pdftk.cat([{:pdf => save_medistrano_pir},{:pdf=> save_agi_iq}])
      end
      
      ####################################################################################################################################    
end
