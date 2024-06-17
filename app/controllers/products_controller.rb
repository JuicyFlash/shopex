class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]
  before_action :find_cart, only: %i[index show]

  def index
    query = Product.with_attached_images.all
    @pagy, @products = pagy(query, items: 6)
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
