class ProductProperty < ApplicationRecord
  belongs_to :product
  belongs_to :property_value
  belongs_to :property
end
