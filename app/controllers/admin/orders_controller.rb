# frozen_string_literal: true

class Admin::OrdersController < Admin::BaseController
  def index
    query = Order.all
    @pagy, @orders = pagy(query, items: 15)
  end
end
