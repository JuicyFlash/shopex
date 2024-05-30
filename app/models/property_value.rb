class PropertyValue < ApplicationRecord
  belongs_to :property
  has_many :product_property
end
