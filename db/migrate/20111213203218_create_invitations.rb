class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.string :rsvp
      t.string :facebook_request_id

      t.timestamps
    end
  end
end
