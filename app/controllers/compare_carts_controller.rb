class CompareCartsController < ApplicationController
  before_action :find_cart, only: %i[product_to_compare show]
  before_action :find_product, only: %i[product_to_compare]

  def show

  end

  def product_to_compare
    if  @compare_cart.product_exist_in_cart?(cart_product_params[:product_id])
      @cart_product = @compare_cart.cart_products.find_by(product_id: cart_product_params[:product_id])

      @cart_product.destroy
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = t('.product_to_compare_remove_note') }
        format.html { redirect_to root_path, notice: t('.product_to_compare_remove_note') }
      end
    else
      @compare_cart.cart_products.new(cart_product_params)
      if @compare_cart.save
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = t('.product_to_compare_note') }
          format.html { redirect_to root_path, notice: t('.product_to_compare_note') }
        end
      else
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = t('.wrong_product_to_compare_note') }
          format.html { redirect_to root_path, notice: t('.wrong_product_to_compare_note') }
        end
      end
    end
  end

  private

  def cart_product_params
    params.require(:product).permit(:product_id)
  end

  def find_product
    @product = Product.with_attached_images.find_by(id: cart_product_params[:product_id])
  end
end
