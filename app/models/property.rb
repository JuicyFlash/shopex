class Property < ApplicationRecord
  has_many :property_values, dependent: :destroy
end
