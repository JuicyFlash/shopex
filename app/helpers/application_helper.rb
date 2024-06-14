module ApplicationHelper
  include Pagy::Frontend

  def format_price(price)
    "#{price} ₽"
  end

  def nav_cart_price(cart)
    format_price(cart.total)
  end

  def nav_cart_products(cart)
    "#{t('helpers.nav_cart_products')}: #{cart.products_count}"
  end
end
