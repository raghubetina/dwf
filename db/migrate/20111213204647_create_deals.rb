class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :deal_url
      t.string :large_image_url
      t.string :title
      t.string :start_at
      t.string :expires_at
      t.string :buy_url
      t.string :details
      t.string :price

      t.timestamps
    end
  end
end
