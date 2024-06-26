# frozen_string_literal: true

class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def price
    product.price
  end

  def total_price
    product.price * quantity
  end
end
