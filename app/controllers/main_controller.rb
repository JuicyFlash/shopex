class MainController < ApplicationController
  before_action :find_cart, only: %i[index show]

  def index
    @recommended_products = Product.last(9)
    @top_ordered_products = Product.first(9)
    @top_products = Product.last(9)
  end

  def show; end

  private

  def find_cart
    @cart = cart_service.cart
  end
end
