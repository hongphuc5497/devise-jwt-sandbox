class CreateUserProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :user_properties do |t|
      t.integer :user_id
      t.string :nickname
      t.string :zip
      t.string :address
      t.string :telephone
      t.timestamps
    end
  end
end
