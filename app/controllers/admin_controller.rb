class AdminController < ApplicationController

before_action :authenticate_user!
before_action :check_admin_privilage


  def index
    @products = Product.all.paginate({per_page: 5, page: params[:page]})
    session[:current_page] = params[:page]
  end

  def edit
    @product = Product.find(params[:id])
  end

  def new
  end

  def create
  end

  def show
    @product = Product.find(params[:id])
  end

  def destroy
    @product = Product.find(params[:id])
    @name = @product.name
    if @product.destroy
      redirect_to admin_index_path, notice: "Product #{@name} removed from database!"
    else
      redirect_to admin_index_path, alert: "Product #{@name} was not deleted!"
    end
  end

  def update
    @product = Product.find(params[:id])
    if params["product"]["quantity"].to_i <= 0
      flash.now[:alert] = "Please enter number bigger than 0!"
      render :show
    else
      if check_event
        flash.now[:notice] = "Iventory Status Changed!"
        render :show
      else
        flash.now[:alert] = "Inventory Status Was Unchanged!"
        render :show
      end
    end
  end

  def import
    if params[:file] == nil
      redirect_to admin_index_path, alert: "No File Selected!"
    else
      Product.import(params[:file])
      redirect_to admin_index_path, notice: "Products imported."
    end
  end

  private

  def check_admin_privilage
    if current_user.is_admin? == false
      redirect_to root_path, alert: "Access Denied"
    end 
  end

  def check_event
    if params[:event] == "set_product_amount"
      if @product.update_attributes(params.require(:product).permit(:quantity))
        @product.product_ready_for_sell
      end
    elsif params[:event].present?
      if params[:event] == "product_ready_for_sell"
        @product.product_ready_for_sell
      elsif params[:event] == "inventory_sold_out"
        @product.inventory_sold_out
      elsif params[:event] == "remove_product"
        @product.remove_product
      end
    else
      @product.update_attributes(params.require(:product).permit(:quantity, :name, :description, :price, :category_id))
    end
  end


end
