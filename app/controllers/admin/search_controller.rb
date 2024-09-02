# frozen_string_literal: true

class Admin::SearchController < Admin::BaseController
  before_action :current_params, only: %i[products_show orders_show]

  def products_show
    @pagy, @products = pagy(SearchService.search_products_with_params(@current_params), items: 10)
  end

  def orders_show
    @pagy, @orders = pagy(SearchService.search_orders_with_params(@current_params), items: 10)
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
end
