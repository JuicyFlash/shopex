class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]
  before_action :find_cart, only: %i[index show]

  def index
    @brands = Brand.all
    @filtered_brands = params[:brands] || []
    ids = Product.search :with => { :brand_id => @filtered_brands }
    query = Product.with_attached_images.where(:id => ids)
    @pagy, @products = pagy(query, items: 6)
    @current_params = { brands: @filtered_brands }
    respond_to do |format|
      format.turbo_stream {  }
      format.html { render 'index' }
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
