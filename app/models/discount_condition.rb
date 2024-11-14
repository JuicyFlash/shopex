class DiscountCondition < ApplicationRecord
  belongs_to :discount, optional: true

  validates :value, :condition_type, presence: true
end
