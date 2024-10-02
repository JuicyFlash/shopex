class CreateDiscountConditions < ActiveRecord::Migration[7.1]
  def change
    create_table :discount_conditions do |t|
      t.string :condition_type
      t.text :value

      t.timestamps
    end
    add_reference :discount_conditions, :discount, foreign_key: true
  end
end
