# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_cart, only: %i[create index]
  before_action :load_discount_service, only: %i[create]

  def index
    return if current_user.nil?

    @orders = current_user.orders
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = current_user.id if current_user.present?
    @cart.cart_products.find_each do |cart_product|
      discount_details = discount_service.discount_for(cart_product.product,'order', user: current_user, order: @cart)
      order_product = @order.order_products.new(product_id: cart_product.product_id,
                                                quantity: cart_product.quantity,
                                                price: cart_product.price,
                                                discount_price: discount_details[:discount_price],
                                                discount_value: discount_details[:discount_value])
      discount_details[:discounts].each do |discount|
        order_product.order_product_discounts.new(discount_description: discount.description,
                                                  discount_value: discount.value,
                                                  discount_target: discount.target,
                                                  discount_id: discount.id)
      end
    end
    if @order.save
      @cart.cart_products.destroy_all
      respond_to do |format|
        format.turbo_stream { flash[:notice] = t('.create_note') }
        format.html { flash[:notice] = t('.create_note') }
      end
      redirect_to(root_path)
    else
      respond_to do |format|
        format.turbo_stream { flash[:notice] = t('.wrong_create_note') }
        format.html { flash[:notice] = t('.wrong_create_note') }
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(detail_attributes: %i[first_name last_name city phone_number street house_number])
  end
end
