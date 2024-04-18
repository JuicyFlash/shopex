class CreateCartProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_products do |t|
      t.integer :quantity, default: 1

      t.timestamps
    end
    add_reference :cart_products, :cart, foreign_key: true
    add_reference :cart_products, :product, foreign_key: true
  end
end
