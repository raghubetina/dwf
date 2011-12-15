class User < ActiveRecord::Base

  
  has_many :proposals
  has_many :invitations
  
end
