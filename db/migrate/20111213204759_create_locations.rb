class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.bigint :deal_id
      t.string :street_address_1
      t.string :street_address_2
      t.string :postal_code
      t.string :country
      t.string :lat
      t.string :lng
      t.string :phone_number
      t.string :state
      t.string :city

      t.timestamps
    end
  end
end
