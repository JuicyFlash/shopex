# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_products, foreign_key: 'order_id', class_name: 'OrderProduct', dependent: :destroy
  has_many :products, through: :order_products
  has_one :detail, foreign_key: 'order_id', class_name: 'OrderDetail'
  belongs_to :user, optional: true

  accepts_nested_attributes_for :detail
end
