class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_privilage, only: [:index_admin, :update]

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  def index_admin
    @pending_orders = Order.pending
    @processing_orders = Order.processing
    @shipped_orders = Order.shipped
    @canceled_orders = Order.canceled
  end

  def update
    @order = Order.find(params[:id])
    if check_event
      redirect_to @order
    end
  end

  private

  def check_admin_privilage
    if current_user.is_admin? == false
      redirect_to root_path, alert: "Access Denied"
    end 
  end

  def check_event
    if params[:event] == "confirmed"
      @order.confirmed
    elsif params[:event] == "ship"
      @order.ship
    elsif params[:event] == "cancel"
      @order.cancel
    end

  end
end
