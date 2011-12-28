class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.bigint :proposal_id
      t.bigint :facebook_user_id
      t.string :rsvp, :default => "Maybe"
      t.string :facebook_request_id

      t.timestamps
    end
  end
end
