# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_products, foreign_key: 'order_id', class_name: 'OrderProduct', dependent: :destroy
  has_many :products, through: :order_products
  has_one :detail, foreign_key: 'order_id', class_name: 'OrderDetail'
  belongs_to :user, optional: true

  accepts_nested_attributes_for :detail

  after_create :new_order_email_notify, :new_order_telegram_notify

  def total
    res = 0
    order_products.find_each do |order_product|
      res += order_product.price * order_product.quantity
    end
    res
  end

  def author
    "#{detail.first_name} #{detail.last_name}"
  end

  def delivery_adress
    "#{detail.city} #{detail.street} #{detail.house_number}"
  end

  private

  def new_order_email_notify
    OrderEmailNotifyJob.perform_later(self)
  end

  def new_order_telegram_notify
    OrderTelegramNotifyJob.perform_later(self)
  end
end
