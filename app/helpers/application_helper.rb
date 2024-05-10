module ApplicationHelper
  def nav_cart_price(cart)
    cart.total
  end
  def nav_cart_products(cart)
    "товаров: #{cart.products_count}"
  end
end
