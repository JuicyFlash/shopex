class AddTypeToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :type, :string, null: false, default: 'Cart'
  end
end
