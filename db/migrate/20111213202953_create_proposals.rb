class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :user_id
      t.string :groupon_id
      t.string :announcement_title
      t.datetime :proposed_datetime
      t.integer :min_companions
      t.integer :max_companions
      t.integer :tipped
      t.string :facebook_event_id

      t.timestamps
    end
  end
end
