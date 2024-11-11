class Discount < ApplicationRecord
  has_many :conditions,  foreign_key: 'discount_id', class_name: 'DiscountCondition', dependent: :destroy

  accepts_nested_attributes_for :conditions, allow_destroy: true

  validates :value, :description, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
