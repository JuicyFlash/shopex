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
end
