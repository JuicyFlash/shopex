# frozen_string_literal: true

class Admin::SearchController < Admin::BaseController

  def products_show
    @query = params[:query]
    ids = Product.search(@query)
    query = Product.where(:id => ids)
    @pagy, @products = pagy(query, items: 10)
    @current_params = { query: @query,
                        page: @pagy.page }
  end

  def orders_show
    @query = params[:query]
    ids = Order.search(@query)
    query = Order.where(:id => ids)
    @pagy, @orders = pagy(query, items: 10)
    @current_params = { query: @query,
                        page: @pagy.page }
  end
end
