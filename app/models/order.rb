class Order < ActiveRecord::Base
  belongs_to :user

  serialize :body

  scope :pending, -> { where(state: :pending) }
  scope :processing, -> { where(state: :processing) }
  scope :shipped, -> { where(state: :shipped) }
  scope :canceled, -> { where(state: :canceled) }

  state_machine :state, initial: :pending do 

    event :confirmed do
      transition pending: :processing
    end

    event :ship do
      transition processing: :shipped
    end

    event :cancel do
      transition [:pending, :processing] => :canceled
    end

  end

end
