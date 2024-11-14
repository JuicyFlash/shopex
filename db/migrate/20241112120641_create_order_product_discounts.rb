class CreateOrderProductDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :order_product_discounts do |t|
      t.text :discount_description
      t.string :discount_target
      t.integer :discount_value
      t.integer :discount_id
      t.timestamps
    end
    add_reference :order_product_discounts, :order_product, foreign_key: true
  end
end
