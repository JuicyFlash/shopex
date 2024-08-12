class ProductsController < ApplicationController
  before_action :find_product, only: %i[show]
  before_action :find_cart, only: %i[index show]

  def index
    @brands = Brand.all
    @properties = Property.with_values
    @current_params = { brands:  products_params[:brands] || [],
                        properties:  products_params[:properties].to_h || {} }
    /ids =  Product.search :with=> {:brand_id => @filtered_brands}, :with_all => {:value_ids => properties_values.map{|v| v.to_i}}/
    query = Product.with_attached_images.get_products_by_params(@current_params)
    @pagy, @products = pagy(query, items: 9)

    respond_to do |format|
      format.turbo_stream {  }
      format.html { render 'index' }
    end
  end

  def show; end

  private

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
