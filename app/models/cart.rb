# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_products, foreign_key: 'cart_id', class_name: 'CartProduct', dependent: :destroy
  has_many :products, through: :cart_products
  belongs_to :user, optional: true
  def product_exist_in_cart?(product_id)
    cart_products.exists?(product_id: product_id)
  end

  def products_count
    cart_products.sum(:quantity)
  end

  def copy_cart_products_from(source_cart_id)
    CartProduct.where(cart_id: source_cart_id).update_all(cart_id: id)
  end

  def total
    res = 0
    cart_products.find_each do |cart_product|
      res += cart_product.product.price * cart_product.quantity
    end
    res
  end

  def total_with_discount(discount_service, options = {})
    return total if discount_service.nil?

    res = 0
    cart_products.find_each do |cart_product|
      res += discount_service.discount_for(cart_product.product, 'order', order: self, user: options[:user])[:discount_price] * cart_product.quantity
    end
    res
  end
end
