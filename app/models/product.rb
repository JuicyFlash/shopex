class Product < ApplicationRecord
  belongs_to :brand
  has_many :product_property

  accepts_nested_attributes_for :product_property, reject_if: proc { |attributes|
                                                                attributes['property_value_id'].blank? ||
                                                                  attributes['property_value_id'].to_i < 0
                                                              }

  has_many_attached :images, dependent: :destroy

  validates :title, :description, presence: true

  def have_property_value?(value)
    !product_property.find_by(property_value_id: value.id).nil?
  end
end
