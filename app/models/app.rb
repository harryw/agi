class App < ActiveRecord::Base
    
    belongs_to :customer
    belongs_to :project
    belongs_to :database
    belongs_to :chef_account

    has_many :deployments
    has_many :customizations, :as => :customizable
    
    delegate :name, :name_tag, :configuration, :to => :project, :prefix => true, :allow_nil => true
    delegate :name, :name_tag, :configuration, :to => :customer,:prefix => true, :allow_nil => true
    delegate :name, :configuration, :ready?, :started, :to => :database,:prefix => true, :allow_nil => true
    delegate :name, :update_data_bag_item, :to => :chef_account, :prefix => true, :allow_nil => true
    
    after_initialize :set_default_values
    before_validation :generate_default_values, :remove_trailing_slash
    
    validates_presence_of :customer, :project, :chef_account, :stage_name
    validates_uniqueness_of :name
    
    
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
        data_bag_item_data #.to_json
    end
    
    def required_packages
      if platform == "ctms"
        %w{ ttf-dejavu ttf-liberation libxerces2-java libxerces2-java-gcj mysql-client }
      else
        %w{ libxml2-dev libxslt-dev libmysqlclient-dev }
      end
    end
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:stage_name,:deploy_to,:deploy_user,:deploy_group,:multi_tenant,
        :uses_bundler,:alert_emails,:url,:git_branch,:git_revision,:rails_env,:platform).merge(:required_packages => required_packages).merge(:custom_data => custom_data).reject{|k,v| v.blank? }
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
        end
      end
        
end


=begin
{
    "project": {
        "name": "imagegateway",
        "repository": "git@github.com:mdsol/image_gateway.git",
        "repo_private_key": "-----BEGIN RSA PRIVATE KEY-----\nMIIEoQIBAAKCAQEAvohaeiLYlzg85d7zMJtxWgtLTFmHSt+CxHuZ4MJNHC8UOc9P\nMpQ26ijqK7Hg1zkxezQ87mrtKAEjhq3TjKeCdAJZYnrqCWyV8aPTo7VT7ZindjFh\npfZJRG2vIYk2xg3ckqzX4TKGqxKI2yHtNEMVDIPKv8NzftxzpP0pY+bjENdtlM/d\n5rxR/BIqImzklQENRoL8nZF5RwOwainMc2JBWw0xUBURNDFTu3idWblYCLHNXXxJ\nIYsg1OB36FtGLeZ42BBulFYrmObBV5TqUAqnyqCU572jsQuhTS/I0gJlZEyZJxUs\n8BCjPXNJ/BYXYR3j32WE2rCASJPE1T98H1cxPwIBIwKCAQEAuRa+SsLDxhlfurtS\npD866cHUHkhXio/7X8iG2lZZiRfKgU0LGzDk43gz7+6f5wRb9AbcGs5Fd1GQObAs\nl0OjTB+KB+Ud3UTpbmShtPlKN0PV4Ie98a1rvtDzRSY1NWyNIMUpe61s4LLrWIdb\ndJjv4EWDIK88/uTIHJ4oNSlu3SddO78A0S86q8Fo+dT29h2T5rLNEw587Nn5+yNC\nVYoIVobgdar3fkNjg6EfDDUs+3BdhEszG7KvMgOtMpDGiXhroqoFq6fqAP9igBwg\ngj3G0hWyLYejNhB3g3Sx7ktwVx9+LagBlFO2Aj6LYjpaLMbnsPNLHXLDB6A7KV6h\nENmISwKBgQDszsYM/bZdDSydDiAkfHr5I5uYvBkZiieWD4s/LLNZZTsWg+498EsT\nMpCMjXYakWj6XUe6A5r/1qtdpZmkxV0FuTZCIAWzTmBLVzFlf0SaWUVqM9G0A5BF\nfYHIMNpUUNsJteYxVNXr9YOlBPmDsF7tqDn6URpaSl9t0SZ/GR7zLwKBgQDN+Xnm\nqEZHmHFGqbVJZnawl01yqDTBBUcCbq72Kt0MjbCsNOfFbxlaF/5w1ki8VlUncH28\nY07G/22NncMvYo18yjo1rQV/4BYnMTeBd+DP1VPkOcIxE/Hv12qUwnD/UFirq5if\noKhOvhisEf6gRmqtW15Evhh7WDySlb8a/Gde8QKBgBRMPNyKxn0BIRTGskxFLxyr\nR9nkPKpq7XNDKTFM+W4P/cAZ79lsXjTYcso4As8TxytnFMbNG+oLFgC2bEFSvtSa\n2MPW2+rMNCO3BDvmVlZfbFmPab74/bzQPlL834OR5uOTP53UElYNutOhVzcsX+h8\nIjoG86FW1PrIyMkQyCN5AoGARp6tc6dojZNaCZlFeEBjNRgKkojZXUrlDlI\nA0sCgYAM0Vy2wj+H4y9T+t1gvYqA+MSSh/yERHmL169xRQHcum/wGl05bTNFwOeO\nbGwT3mydmqOEqPPjZQalPanC+r2LvoOkpFkBmF39upO41OWAL1z2X6yHo63/niPW\nSjuuf1QRXGYk2fnOFDFC/0scX21AQ8mzux5JLoGqoudAMPrkvg==\n-----END RSA PRIVATE KEY-----\n",
        "homepage": "http://github.com/mdsol/image_gateway",
        "name_tag": "imagegateway"
    },
    "id": "imagegateway-medidata-sandbox",
    "main": {
        "name": "imagegateway-medidata-sandbox", # take out of DB
        "force": "false",
        "deploy_user": "medidata",
        "stage_name": "sandbox",
        "required_packages": [
            "libxml2-dev",
            "libxslt-dev",
            "libmysqlclient-dev"
        ],
        "url": "imagegateway-sandbox.imedidata.net",
        "alert_emails": "jcaaaan@mdsol.com",
        "run_migrations": "true",
        "migration_command": "bundle exec rake db:migrate",
        "uses_bundler": "true",
        "multi_tenant": "",
        "rails_env": "development",
        "deploy_group": "medidata",
        "git_revision": "d425dbe908673c333819cccc3de26fdd0df",
        "deploy_to": "/mnt/imagegateway",
        "platform": "rails"
    },
    "database": {
        "name": "imagegateway_sandbox",
        "db_name": "imagegateway_sandbox",
        "username": "imagegateway",
        "db_type": "mysql",
        "hostname": "test-sandbox-aaaaaa.cz4lsbnwubdn.us-east-1.rds.amazonaws.com",
        "password": "ddddddddca5f89b7a95c44b8bb9b"
    },
    "customer": {
        "name": "Medidata",
        "name_tag": "medidata"
    },
    "deployment_timestamp": "2011-10-31T16:13:53Z"
}
=end