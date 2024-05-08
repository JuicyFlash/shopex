# frozen_string_literal: true

class ChangePriceTypeInOrderProducts < ActiveRecord::Migration[7.1]
  def change
    change_column :order_products, :price, :decimal, precision: 10, scale: 2, default: 0
  end
end
