class Database < ActiveRecord::Base
    def configuration
        attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:type)
    end
end
