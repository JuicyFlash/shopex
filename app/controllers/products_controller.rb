class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]
  before_action :find_cart, only: %i[index show]
  before_action :current_params, only: %i[index]
  before_action :load_discount_service, only: %i[index show]

  def index
    @brands = Brand.all
    @properties = Property.with_values
    @pagy, @products = pagy(SearchService.get_products_by_params(@current_params), items: 9)

    respond_to do |format|
      format.turbo_stream
      format.html { render 'index' }
    end
  end

  def show
    @properties = @product.properties.distinct
    @product_properties = @product.product_property
  end

  private

  def current_params
    @current_params = { brands: products_params[:brands] || [],
                        properties: products_params[:properties].to_h || {} }
  end

  def products_params
    params.permit(brands: [], properties: {})
  end

  def find_product
    @product = Product.with_attached_images.find_by(id: params[:id])
  end

  def find_cart
    @cart = cart_service.cart
  end
end
