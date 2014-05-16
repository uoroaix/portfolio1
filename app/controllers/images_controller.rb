class ImagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :check_admin_privilage, except: [:show]

  def index
    @image = Image.new
  end

  def show
    @image = Image.find(params[:id])
    respond_to do |format|
      if @image
        format.js   {render}
      else
        format.js   {render js: "alert('ERROR');"}
      end
    end
  end

  def create
    @image = Image.new(image_attributes)
    if @image.save
      redirect_to images_path, notice: "success upload"
    else
      redirect_to images_path, alert: "uploading failed"
    end
  end

  private

  def image_attributes
    params.require(:image).permit(:image, :product_id)
  end

  def check_admin_privilage
    if current_user.is_admin? == false
      redirect_to root_path, alert: "Access Denied"
    end 
  end

end
