# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_cart, only: %i[create index]

  def index
    return if current_user.nil?

    @orders = current_user.orders
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = current_user.id if current_user.present?
    @cart.cart_products.find_each do |cart_product|
      @order.order_products.new(product_id: cart_product.product_id, quantity: cart_product.quantity,
                                price: cart_product.price)
    end
    return unless @order.save

    @cart.cart_products.destroy_all
    respond_to do |format|
      format.turbo_stream { flash[:notice] = t('.create_note') }
      format.html { flash[:notice] = t('.create_note') }
    end
    redirect_to(root_path)
  end

  private

  def order_params
    params.require(:order).permit(detail_attributes: %i[first_name last_name city phone_number street house_number])
  end

  def find_cart
    @cart = cart_service.cart
  end
end
