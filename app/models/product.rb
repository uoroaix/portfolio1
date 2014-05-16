require 'csv'

class Product < ActiveRecord::Base
  belongs_to :category
  has_many :carts, through: :cart_products
  has_many :cart_products
  has_many :images, dependent: :destroy
  validate :add_stocks, on: :update

  scope :draft, -> { where(state: :draft)}
  scope :off_shelves, -> { where(state: :off_shelves)}
  scope :sort_by_desc, -> {order("created_at DESC")}
  scope :product_for_sell, 
    -> { where("state LIKE 'in_stock' OR state LIKE 'sold_out'")}

  state_machine :state, initial: :draft do 

    event :product_ready_for_sell do
      transition [:draft, :sold_out] => :in_stock
    end

    event :inventory_sold_out do
      transition in_stock: :sold_out
    end

    event :remove_product do
      transition [:in_stock, :sold_out] => :off_shelves
    end

  end


  private

  def add_stocks
    if self.quantity == "0"
      errors.add(:base, "Cannot Add 0!") 
    end
  end


  def self.import(file)
    CSV.foreach(file.path, col_sep: ";", headers: true) do |row|
      Product.create! row.to_hash
    end
  end


  def self.search_by(search_term)
    where(["LOWER(name) LIKE :search_term OR
            LOWER(description) LIKE :search_term",
            {search_term: "%#{search_term.downcase}%"}]
         )
  end



end
