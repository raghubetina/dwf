class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :proposal_id
      t.integer :facebook_user_id
      t.string :rsvp, :default => "Maybe"
      t.string :facebook_request_id

      t.timestamps
    end
  end
end
