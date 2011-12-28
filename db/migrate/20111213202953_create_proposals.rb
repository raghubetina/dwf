class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.bigint :user_id
      t.string :groupon_id
      t.datetime :proposed_datetime
      t.bigint :min_companions
      t.bigint :max_companions
      t.bigint :tipped
      t.string :facebook_event_id

      t.timestamps
    end
  end
end
