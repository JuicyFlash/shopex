module PriceHelper
  def format_price(price)
    "#{price} ₽"
  end

  def discount_catalog_for(product)
    @discount_service.discount_for(product, 'catalog', user: current_user, order: @cart)
  end

  def discount_order_for(product)
    @discount_service.discount_for(product, 'order', user: current_user, order: @cart)
  end

  def nav_cart_price(cart)
    format_price(cart.total_with_discount(@discount_service, user: current_user))
  end
end