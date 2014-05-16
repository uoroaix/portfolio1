class RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    profile = Profile.new
    profile.user = current_user
    cart = Cart.new
    cart.user = current_user
    profile.save
    cart.save
    edit_profile_path(profile)
  end



end 