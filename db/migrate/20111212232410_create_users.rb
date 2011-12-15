class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :facebook_user_id
      t.string :facebook_access_token
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :location_id
      t.string :location_name
      t.string :gender
      t.string :timezone
      t.string :updated

      t.timestamps
    end
  end
end
