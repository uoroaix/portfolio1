class CartsController < ApplicationController
  before_action :authenticate_user!

  def update
    @cart = current_user.cart
    if @cart.update(cart_attributes)
      redirect_to @cart
    else
      flash.now[:alert] = "#{@cart.errors.messages[:"cart_products.base"].join(" ,")}"
      render :edit
    end
  end

  def edit
    @cart = current_user.cart
  end

  def show
    @cart = current_user.cart
  end

  def destroy
    @cart = current_user.cart
    @cart_product = @cart.cart_products.find(params[:id])
    if @cart_product.destroy
      render
    else
      render :edit
    end
  end

  def add_to_cart
    product = Product.find(params[:id])
    if current_user.cart.add_product(params[:id])
      redirect_to product, notice: "Added To Your Cart"
    else
      redirect_to product, alert: "Failed to add to cart"
    end
  end

  private

  def cart_attributes
    params.require(:cart).permit({cart_products_attributes: [:quantity, :id]})
  end

end
