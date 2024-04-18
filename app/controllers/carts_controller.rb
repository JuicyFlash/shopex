# frozen_string_literal: true

class CartsController < ApplicationController

  before_action :find_cart, only: %i[put_product show]

  def show; end
  def put_product
    if @cart.product_exist_in_cart?(cart_product_params[:product_id])
      cart_product = @cart.cart_products.find_by(product_id: cart_product_params[:product_id])
      cart_product.quantity += cart_product_params[:quantity].to_i
      if cart_product.save
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

  private

  def cart_product_params
    params.require(:product).permit(:product_id, :quantity)
  end

  def find_cart
    @cart = cart_service.cart
  end
end
