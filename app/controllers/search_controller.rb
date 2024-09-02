# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :find_cart, only: %i[products_show]
  before_action :current_params, only: %i[products_show]

  def products_show
    @brands = Brand.all
    @properties = Property.with_values
    @pagy, @products = pagy(SearchService.search_products_with_params(@current_params), items: 9)

    respond_to do |format|
      format.turbo_stream
      format.html { render 'products_show' }
    end
  end

  private

  def current_params
    @current_params = { query: search_params[:query],
                        brands: search_params[:brands] || [],
                        properties: search_params[:properties].to_h || {} }
  end

  def search_params
    params.permit(:query, :page, brands: [], properties: {})
  end

  def find_cart
    @cart = cart_service.cart
  end
end
