class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :title
      t.string :description
      t.string :price
      t.string :quantity
      t.string :status

      t.timestamps
    end
  end
end
