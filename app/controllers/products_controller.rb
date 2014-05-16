class ProductsController < ApplicationController


  def index
    @products = Product.product_for_sell.paginate({per_page: 5, page: params[:page]})
    session[:current_page] = params[:page]
    if params[:search]
      @search_term = params[:search]
      @products = @products.search_by(@search_term)
    end

  end


  def show
    @product = Product.find(params[:id])
    if @product.off_shelves?
      redirect_to root_path, notice: "No Such Product!"
    else
      render :show, layout: "show_product"
    end
  end

end
