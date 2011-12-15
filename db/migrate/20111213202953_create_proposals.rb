class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.integer :user_id
      t.integer :deal_id
      t.date :proposed_date
      t.time :proposed_time
      t.integer :min_companions
      t.integer :max_companions
      t.integer :tipped
      t.integer :event_created

      t.timestamps
    end
  end
end
