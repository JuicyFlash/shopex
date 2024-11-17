class CreateDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :discounts do |t|
      t.integer :value, default: 0
      t.boolean :active, default: false
      t.string :target

      t.timestamps
    end
  end
end
