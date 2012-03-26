class Customization < ActiveRecord::Base
  belongs_to :customizable, :polymorphic => true
  attr_accessible :name, :location, :value, :prompt_on_deploy, :customizable_id, :customizable_type
  
  #after_save :update_customizable 
  
  def to_hash
    Hash[name,value]
  end
  
  private
  

  def update_customizable
    if customizable_type.constantize == App
      self.customizable.touch
    else
      #TO FIX this produces a Stack too deep, when you save
      self.customizable.save #this has to be change for touch
    end
    
  end
  
end
