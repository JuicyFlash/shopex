class CreateProductProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :product_properties do |t|
      t.timestamps
    end
    add_reference :product_properties, :property, foreign_key: true
    add_reference :product_properties, :property_value, foreign_key: true
    add_reference :product_properties, :product, foreign_key: true
  end
end
