class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :allergies
      t.string :member_code
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
