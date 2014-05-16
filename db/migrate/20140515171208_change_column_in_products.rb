class ChangeColumnInProducts < ActiveRecord::Migration
  def change
    remove_column :products, :status, :string
    add_column :products, :state, :string
    add_index :products, :state
  end
end
