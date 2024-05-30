class CreatePropertyValues < ActiveRecord::Migration[7.1]
  def change
    create_table :property_values do |t|
      t.string :value

      t.timestamps
    end
    add_reference :property_values, :property, foreign_key: true
  end
end
