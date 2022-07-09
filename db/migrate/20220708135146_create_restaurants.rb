class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :lat
      t.string :lng
      t.float :google_rating
      t.string :google_place_id
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
