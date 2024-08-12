# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :find_cart, only: %i[products_show]

  def products_show
    @brands = Brand.all
    @properties = Property.with_values
    search_query = search_params[:query]
    filtered_brands = search_params[:brands] || []
    properties = search_params[:properties].to_h || {}
    properties_values = []
    properties.values.map{ |v| v }.each { |i| properties_values.concat(i) } || []

    ids =  Product.search search_query, :with=> {:brand_id => filtered_brands}, :with_all => {:value_ids => properties_values.map{|v| v.to_i}}
    query = Product.where(:id => ids)
    @pagy, @products = pagy(query, items: 9)
    @current_params = { query: search_query,
                        brands: filtered_brands,
                        properties: properties }
  end

  private

  def search_params
    params.permit(:query, :page, brands: [], properties: {})
  end

  def find_cart
    @cart = cart_service.cart
  end
end
