class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]
  before_action :find_cart, only: %i[index show]

  def index
    query = Product.with_attached_images.all
    @pagy, @products = pagy(query, items: 3)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  private

  def find_product
    @product = Product.with_attached_images.find_by(id: params[:id])
  end

  def find_cart
    @cart = cart_service.cart
  end
end
