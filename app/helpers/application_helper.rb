module ApplicationHelper
  def nav_cart_name(cart)
    "Cart #{cart.products_count}  total: #{cart.total}"
  end
end
