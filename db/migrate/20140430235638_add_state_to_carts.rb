class AddStateToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :state, :string
    add_index :carts, :state
  end
end
