class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders, &:timestamps
    add_reference :orders, :user, foreign_key: true
  end
end
