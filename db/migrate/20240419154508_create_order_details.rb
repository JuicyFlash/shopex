class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :street
      t.string :house_number
      t.string :phone_number

      t.timestamps
    end
    add_reference :order_details, :order, foreign_key: true
  end
end
