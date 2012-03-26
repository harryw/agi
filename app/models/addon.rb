class Addon < ActiveRecord::Base
  has_many :extensions, :dependent => :destroy
  has_many :apps, :through => :extensions
  has_many :customizations, :as => :customizable
    
  validates_presence_of :name, :value
  validates_uniqueness_of :name
  validate :json_format_of_value
  
  attr_accessible :name, :value
  after_save :create_default_customizations
  
  def customization_hash
    hash = {}
    customizations.each{|c| hash.merge!(c.to_hash)}
    hash
  end
  
  def value_has_valid_json?
    begin
      JSON.parse(value)
    rescue
      false
    end
  end
  
  protected
    def json_format_of_value
      errors[:value] << "is not a valid json" unless value_has_valid_json?
    end
  
  private
    def create_default_customizations
      addon = JSON.parse(value)
      variables = get_values_of_keys(addon,'variables')
      # it doesn't create customizations for erb variables, it will be bind at deployment time if possible
      variables.reject{|k,v| v =~ /<%=\s*(.*)\s*%>/}
      variables.each do |k,v|
        if c = self.customizations.find_by_name(k)
          # the template is authorative
          if c.value != v
            c.value = v
            c.save
          end
        else
          self.customizations.create(:name => k,:value => v)
        end
        
      end
    end
    
    # It extracts a hash from the hash key. If there are two keys it will merge them as long as the values are hashes
    def get_values_of_keys(data,key)
      @result ||= {}
      data.each do |k,v|
        get_values_of_keys(k,key) if v == nil # this means that is an array, it iterates through the array recursively
        if k == key
          if @result[k]
            @result[k].merge!(v) # if another key was already found, we try to merget it. it'll fail if the value is not a hash
          else
            @result = Hash[k,v]
          end
        else
          get_values_of_keys(v,key) if v.is_a? Hash
        end
      end
      @result[key] || {}
    end
  
end
