class ChangeOrderNumberType < ActiveRecord::Migration
  def change
    change_column :orders, :order_number, :string
  end
end
