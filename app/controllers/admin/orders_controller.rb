# frozen_string_literal: true

class Admin::OrdersController < Admin::BaseController
  before_action :find_order, only: %i[show]

  def index
    query = Order.all
    @pagy, @orders = pagy(query, items: 15)
  end

  def show; end

  def dismiss_details
    @order = Order.find_by(id: params[:order_id])
  end

  private

  def find_order
    @order = Order.find_by(id: params[:id])
  end
end
