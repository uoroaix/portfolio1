class AddUserReferencesToProfiles < ActiveRecord::Migration
  def change
    add_reference :profiles, :user, index: {unique: true}
  end
end
