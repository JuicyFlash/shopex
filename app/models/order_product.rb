# frozen_string_literal: true

class OrderProduct < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { only_float: true }

  def total_price
    price * quantity
  end
end
