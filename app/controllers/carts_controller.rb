# frozen_string_literal: true

class CartsController < ApplicationController

  before_action :find_cart, only: %i[put_product add_product sub_product remove_product show]

  def show
    @order = Order.new
    @order_detail = OrderDetail.new
    @order.detail = @order_detail
  end

  def put_product
    @quantity = cart_product_params[:quantity].to_i
    if @cart.product_exist_in_cart?(cart_product_params[:product_id])
      if update_cart_product
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = 'Product successfully added to cart!' }
          format.html { redirect_to root_path, notice: 'Product successfully added to cart!' }
        end
      end
    else
      @cart.cart_products.new(cart_product_params)
      if @cart.save
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = 'Product successfully added to cart!' }
          format.html { redirect_to root_path, notice: 'Product successfully added to cart!' }
        end
      end
    end
  end

  def add_product
    return unless @cart.product_exist_in_cart?(cart_product_params[:product_id])

    @quantity = cart_product_params[:quantity].to_i
    update_cart_product
  end

  def sub_product
    return unless @cart.product_exist_in_cart?(cart_product_params[:product_id])

    @quantity = cart_product_params[:quantity].to_i * -1
    update_cart_product
  end

  def remove_product
    @cart_product = @cart.cart_products.find_by(product_id: cart_product_params[:product_id])

    @cart_product.destroy
  end

  private

  def update_cart_product
    @cart_product = @cart.cart_products.find_by(product_id: cart_product_params[:product_id])
    return if (@cart_product.quantity == 1) && @quantity.negative?

    @cart_product.quantity += @quantity
    @cart_product.save
  end

  def cart_product_params
    params.require(:product).permit(:product_id, :quantity)
  end

  def find_cart
    @cart = cart_service.cart
  end
end
