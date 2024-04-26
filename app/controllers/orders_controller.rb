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
      @order.order_products.new(product_id: cart_product.product_id, quantity: cart_product.quantity)
    end
    if @order.save
      @cart.cart_products.destroy_all
      respond_to do |format|
        format.turbo_stream { flash[:notice] = "Order created #{@order.id}" }
        format.html { flash[:notice] = "Order created #{@order.id}" }
      end
      redirect_to(root_path)
    end
  end

  private

  def order_params
    params.require(:order).permit(detail_attributes: %i[first_name last_name city phone_number street house_number])
  end

  def find_cart
    @cart = cart_service.cart
  end
end
