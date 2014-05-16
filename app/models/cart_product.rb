class CartProduct < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  delegate :name, to: :product
  delegate :price, to: :product

  validate :check_stocks, on: :update


  private


  def check_stocks
    if self.quantity > self.product.quantity.to_i
      errors.add(:base, "Not enough in stock!") 
    end
  end


end
