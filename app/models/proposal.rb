class Proposal < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :proposal
  has_many :invitations
  
end
