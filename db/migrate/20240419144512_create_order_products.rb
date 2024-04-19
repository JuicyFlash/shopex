class CreateOrderProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :order_products do |t|
      t.integer :quantity, default: 1
      t.float :price, default: 0.0

      t.timestamps
    end
    add_reference :order_products, :order, foreign_key: true
    add_reference :order_products, :product, foreign_key: true
  end
end
