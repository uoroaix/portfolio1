class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :birthdate
      t.string :phone
      t.string :suite
      t.string :address
      t.string :city
      t.string :country
      t.string :postal

      t.timestamps
    end
  end
end
