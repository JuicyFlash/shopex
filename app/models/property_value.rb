class PropertyValue < ApplicationRecord
  belongs_to :property
  has_many :product_property, dependent: :destroy

  validates :value, presence: true
end
