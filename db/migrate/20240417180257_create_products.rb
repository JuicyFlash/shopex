class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
    add_reference :products, :brand, foreign_key: true
  end
end
