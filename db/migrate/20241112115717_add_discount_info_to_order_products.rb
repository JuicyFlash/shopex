class AddDiscountInfoToOrderProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :order_products, :discount_price, :decimal, precision: 10, scale: 2, default: 0
    add_column :order_products, :discount_value, :integer, default: 0
  end
end
