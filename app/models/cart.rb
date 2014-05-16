class Cart < ActiveRecord::Base
  belongs_to :user
  has_many :products, through: :cart_products
  has_many :cart_products, dependent: :destroy

  accepts_nested_attributes_for :cart_products


  # def add_product(product)
  #   products << product
  # end

  state_machine :state, initial: :empty do 

  event :add_product do
    transition empty: :loaded
  end

  event :check_out do
    transition loaded: :checked_out
  end

  event :cancel do
    transition loaded: :empty
  end

  end



  def add_product(product_id)
    if Product.find(product_id).in_stock?
      my_product = products.where('product_id = ?', product_id).first
      if my_product
        cp = cart_products.find_by_product_id(product_id)
        cp.quantity += 1
        cp.save
      else
        product = Product.find(product_id)
        products << product
      end
    end
  end


  def sub_total
    price = 0
    products.each do |product|
      price += (product.price.to_f * cart_products.find_by_product_id(product.id).quantity)
    end
    price.round(2)
  end


  def pst
    pst = 0
    pst = sub_total * 0.07
    pst.round(2)
  end

  def gst
    gst = 0
    gst = sub_total * 0.05
    gst.round(2)
  end

  def total_price
    (sub_total + pst + gst).round(2)
  end

  def in_cents
    (total_price * 100)
  end


  def cart_to_order
    list = {} 
    self.cart_products.each do |cp|
      list[cp.name] = {} 
      list[cp.name][:price] = cp.price
      list[cp.name][:quantity] = cp.quantity
    end
    list
  end

end
