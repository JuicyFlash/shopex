class OrderProductDiscount < ApplicationRecord
  belongs_to :order_product, optional: true
  belongs_to :discount, optional: true
end
