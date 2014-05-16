class ChargesController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_user.cart
  end

  def create
    @cart = current_user.cart
    # Amount in cents
    amount = @cart.in_cents.to_i
    @paid = @cart.total_price
    token = params[:stripeToken]

    if current_user.customer_id

      customer = Stripe::Customer.retrieve(current_user.customer_id)
      customer.card = token # obtained with Stripe.js
      customer.save

      charge = Stripe::Charge.create(
        :customer    => current_user.customer_id,
        :amount      => amount,
        :description => 'FruityFruits Stripe customer',
        :currency    => 'cad'
      )

    else
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :card  => token
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => amount,
        :description => 'FruityFruits Stripe customer',
        :currency    => 'cad'
      )

    end


    if charge.paid
      order = Order.new
      order.body = @cart.cart_to_order
      order.user = current_user
      order.order_number = "#{current_user.id}-#{Time.now.to_i}"
      order.paid = @paid
      order.save
      remove_product
      @cart.cart_products.destroy_all
      current_user.customer_id ||= customer.id
      current_user.stripe_card_last4 = customer.cards.data[0].last4
      current_user.stripe_card_type = customer.cards.data[0].type
      current_user.save
    end

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path

  end



  def charge_existing
    @cart = current_user.cart
    amount = @cart.in_cents.to_i
    @paid = @cart.total_price

    charge = Stripe::Charge.create(
      :customer    => current_user.customer_id,
      :amount      => amount,
      :description => 'FruityFruits Stripe customer',
      :currency    => 'cad'
    )

    if charge.paid
      order = Order.new
      order.body = @cart.cart_to_order
      order.user = current_user
      order.order_number = "#{current_user.id}-#{Time.now.to_i}"
      order.paid = @paid
      order.save 
      remove_product
      @cart.cart_products.destroy_all
    end

    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end


  private

  def remove_product
    @cart.cart_products.each do |cp|
      stocks = cp.product.quantity.to_i
      final_stocks = stocks - cp.quantity
      if final_stocks.to_s == "0"
        cp.product.quantity = "Currently Sold Out!"
        cp.product.save
        cp.product.inventory_sold_out 
      else
        cp.product.quantity = final_stocks.to_s
        cp.product.save
      end
    end
  end

end
