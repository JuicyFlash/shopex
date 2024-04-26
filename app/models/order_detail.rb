class OrderDetail < ApplicationRecord
  belongs_to :order, optional: true
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :city
  validates_presence_of :street
  validates_presence_of :house_number
  validates_presence_of :phone_number
end
