class MainController < ApplicationController
  before_action :find_cart, only: %i[index show]
  before_action :load_discount_service, only: %i[index show]

  def index
    @recommended_products = Product.last(9)
    @top_ordered_products = Product.first(9)
    @top_products = Product.offset(9).first(9)
  end

  def show; end
end
