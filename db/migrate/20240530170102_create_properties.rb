class CreateProperties < ActiveRecord::Migration[7.1]
  def change
    create_table :properties do |t|
      t.string :name
      t.boolean :unique, default: false

      t.timestamps
    end
  end
end
