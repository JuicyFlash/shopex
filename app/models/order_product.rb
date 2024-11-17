# frozen_string_literal: true

class OrderProduct < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  has_many :order_product_discounts, dependent: :destroy

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { only_float: true }

  def total_price
    [price, discount_price == 0 ? price : discount_price].min * quantity
  end
end
