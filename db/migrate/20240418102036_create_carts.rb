class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts, &:timestamps
    add_reference :carts, :user, foreign_key: true
  end
end
