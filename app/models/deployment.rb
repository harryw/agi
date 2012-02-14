class Deployment < ActiveRecord::Base
    
    belongs_to :app
    belongs_to :user
    
    delegate :chef_account_update_data_bag_item, :to => :app, :prefix => true
        
    serialize :deployed_data
    
    after_initialize :load_fog_credentials
    # :update_databag will be moved to an asyncronous state later
    before_save :set_initial_status, :save_deployed_data, :update_databag
    after_save :save_iq_file
    
    validates_presence_of :description
      
    def save_iq_file
      pdf = IqDeployment.new(self)
      pdf_file_content = pdf.render
      s3_file_name = "application-iqs/#{app.name}-#{deployed_data[:deployment_timestamp]}.pdf"
      s3.directories.get('columbo-portal-test').files.create(:key => s3_file_name, :body=> pdf_file_content)
    end
    
    def s3
      @s3 ||= Fog::Storage::AWS.new
    end
    
    def load_fog_credentials
      Fog.credentials_path= "config/.fog"
      unless Fog.respond_to?('credentials')
         raise('Please create a config/.fog file with the right credentials')
      else
         puts "S3 credentials loaded!"
      end
    end
    
    def set_initial_status
      self.started_at = Time.now
      self.final_result = 'Pending'
    end
    
    def save_deployed_data
      self.git_repo = app.project.repository
      self.git_commit = app.git_revision
      self.deployed_data = merged_configuration
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
                                                  :migration_command,:deployment_timestamp).merge(:deploy_by => self.user.email)
    end
    
    def merged_configuration
      conf = app.generate_deployment_data
      conf[:main].merge!(configuration)
      conf
    end
    
    
end
