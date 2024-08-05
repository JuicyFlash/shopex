# frozen_string_literal: true

class SearchController < ApplicationController

  def products_show
    @brands = Brand.all
    @query = params[:query]
    ids = Product.search(@query)
    query = Product.where(:id => ids)
    @pagy, @products = pagy(query, items: 9)
    @current_params = { query: @query,
                        page: @pagy.page }
  end
end
