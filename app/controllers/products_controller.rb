class ProductsController < ApplicationController

  before_action :find_product, only: %i[show]
  before_action :find_cart, only: %i[index show]

  def index
    @products = Product.all
  end

  def show; end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def find_cart
    @cart = cart_service.cart
  end
end
