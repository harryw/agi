class Addon < ActiveRecord::Base
  has_many :extensions
  has_many :apps, :through => :extensions
  validates_presence_of :name, :value
  validates_uniqueness_of :name
  attr_accessible :name, :value
end
