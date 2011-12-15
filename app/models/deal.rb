class Deal < ActiveRecord::Base
  
  has_many :proposals
  has_many :locations
  
end
