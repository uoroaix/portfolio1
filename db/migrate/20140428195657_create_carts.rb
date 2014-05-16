class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|

      t.timestamps
    end
    add_reference :carts, :user, index: {unique: true}
  end
end
