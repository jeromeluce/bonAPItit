class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :address
      t.string :latlng
      t.string :address_visualization
      t.integer :radius
      t.string :registration_code
      t.string :admin_code

      t.timestamps
    end
  end
end
