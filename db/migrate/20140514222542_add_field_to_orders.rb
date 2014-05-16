class AddFieldToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :paid, :float   
  end
end
