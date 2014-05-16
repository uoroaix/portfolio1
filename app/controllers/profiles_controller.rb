class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, except: [:index, :new, :create]

  def index
    redirect_to root_path
  end

  def show
    render nothing: true
  end


  def new
    if current_user.profile == nil
      @profile = Profile.new
    else
      redirect_to root_path, notice: "You already have a profile!"
    end
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(profile_attributes)
      redirect_to root_path, notice: "Billing Information Saved!"
    else
      flash.now[:error] = "Couldn't update!"
      render :edit
    end
  end

  def create
    if current_user.profile == nil
      @profile = Profile.new(profile_attributes)
      @profile.user = current_user
      if @profile.save
        redirect_to root_path, notice: "Billing Information Save Successfully!"
      else
        render :new
      end
    else
      redirect_to root_path, notice: "Access Denied!"
    end
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  private

  def profile_attributes
    params.require(:profile).permit([:first_name, :last_name, :birthdate, :phone, :suite, :address, :state, :city, :country, :postal])
  end


  def check_user
    if Profile.find_by_id(params[:id])
      @profile = Profile.find(params[:id])
      if current_user != @profile.user
        redirect_to root_path, alert: "Access Denied!"
      end
    else
      redirect_to root_path, alert: "Sorry we couldn't find that webpage"
    end
  end


end
