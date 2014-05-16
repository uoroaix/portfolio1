class CategoriesController < ApplicationController

  def index
    @title = Category.find(params[:type]).name.pluralize.capitalize
    @products = Category.find(params[:type]).products.
      where("state LIKE 'in_stock' OR state LIKE 'sold_out'").
        order("created_at DESC").
          paginate({per_page: 5, page: params[:page]})
    session[:current_page] = params[:page]
  end

end
