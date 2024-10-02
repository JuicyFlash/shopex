class Discount < ApplicationRecord
  has_many :conditions,  foreign_key: 'discount_id', class_name: 'DiscountCondition', dependent: :destroy

end
