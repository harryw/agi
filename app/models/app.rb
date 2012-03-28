class App < ActiveRecord::Base
    
    belongs_to :customer
    belongs_to :project
    belongs_to :database
    belongs_to :chef_account

    has_many :deployments
    has_many :customizations, :as => :customizable
    has_many :extensions, :dependent => :destroy
    has_many :addons, :through => :extensions, :dependent => :destroy
    
    delegate :name, :name_tag, :configuration, :platform, :to => :project, :prefix => true, :allow_nil => true
    delegate :name, :name_tag, :configuration, :to => :customer,:prefix => true, :allow_nil => true
    delegate :name, :configuration, :ready?, :started, :to => :database,:prefix => true, :allow_nil => true
    delegate :name, :update_data_bag_item, :to => :chef_account, :prefix => true, :allow_nil => true
    
    after_initialize :set_default_values
    before_validation :generate_default_values, :remove_trailing_slash
    
    validates_presence_of :customer, :project, :chef_account, :stage_name
    validates_uniqueness_of :name
    
    attr_accessible :name, :description, :stage_name, :deploy_to, :deploy_user, :deploy_group, :alert_emails, :url, :git_revision,:rails_env,  :customer_id, :project_id, 
    :chef_account_id, :multi_tenant, :uses_bundler, :database_id, :git_branch, :auto_generate_database, :ec2_sg_to_authorize, :addon_ids
    
    def addons_configuration
      addons_conf = {}
      addons.each do |addon|
        template = Erubis::Eruby.new(addon.value)
        vars = effective_configuration(addon.name)
        result = template.result(vars.merge(agi_vars))
        addons_conf.merge!(Hash[addon.name,JSON.parse(result)])
      end
      addons_conf
    end
    
    # returns a hash that is a result of the addons configuration overridden by the app(extension) configuration
    def effective_configuration(key=nil)
      conf = {}
      extensions.each do |extension|
        extension_hash = extension.customization_hash
        addon_hash = extension.addon.customization_hash
        addon_conf = Hash[extension.addon.name,addon_hash.merge(extension_hash)]
        conf.merge!(addon_conf)
      end
      key ? conf[key] : conf
    end
    
    def agi_vars
      @agi_vars ||= Hash[:agi,data_bag_item_data]
    end
    
    def remove_trailing_slash
      self.deploy_to.sub!(/(\/)+$/,'')
    end
    
    def generate_default_values
      self.name = generate_name
      self.deploy_to = '/mnt/' + generate_name
    end
    
    def generate_name
      [project_name_tag,customer_name_tag,stage_name].join('-')
    end
    
    # Rename this function
    def databag_item_timestamp
        # TODO, last sucessful deployment 
        self.deployments.last.try(:deployment_timestamp)
    end
    
    def app_timestamp
        self.updated_at
    end
    
    def generate_deployment_data
        data_bag_item_data.merge(:addons => addons_configuration)
    end
    
    def required_packages
      if project_platform == "ctms"
        %w{ ttf-dejavu ttf-liberation libxerces2-java libxerces2-java-gcj mysql-client }
      else
        %w{ libxml2-dev libxslt-dev libmysqlclient-dev }
      end
    end
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:stage_name,:deploy_to,:deploy_user,:deploy_group,
        :multi_tenant,:uses_bundler,:alert_emails,:url,:git_branch,:git_revision,:rails_env).merge(:required_packages => 
        required_packages).merge(:custom_data => custom_data).merge(:platform => project_platform).reject{|k,v| v.blank? }
    end
    
    def custom_data
      data = customizations.where(:location=> "").where(:prompt_on_deploy => false)
      Hash[*data.map {|c| c.attributes.symbolize_keys.extract!(:name,:value).values }.flatten]
    end
    
    
    def data_bag_item_data
      {  
         :id => name,
         :deployment_timestamp => app_timestamp,
         :main => configuration,
         :project => project_configuration,
         :customer => customer_configuration,
         :database => database_configuration
      }.reject{|k,v| v.blank? }
    end
    
    def update_data_bag_item
      chef_account_update_data_bag_item(data_bag_item_data)
    end
    
    def database_attached?
      self.database
    end
    
    private
    
      def set_default_values
        if new_record?
          self.deploy_user ||= 'medidata'
          self.deploy_group ||= 'medidata'
          self.git_branch ||= 'master'
          self.alert_emails ||= ''
          self.rails_env ||= 'production'
        end
      end
        
end


