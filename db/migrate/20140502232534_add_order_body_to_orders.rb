class AddOrderBodyToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :body, :text
  end
end
