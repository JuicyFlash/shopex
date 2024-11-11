# frozen_string_literal: true

class AddDescriptionToDiscounts < ActiveRecord::Migration[7.1]
  def change
    add_column :discounts, :description, :text
  end
end
