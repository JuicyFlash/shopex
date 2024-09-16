# frozen_string_literal: true

require 'rails_helper'

feature 'User can view details of selected product' do

  given!(:product) { create(:product) }
  given!(:product_properties) { create_list(:product_property, 3 , product: product) }

  scenario 'view details of product' do
    visit product_path(product)

    expect(page).to have_content product.title
    expect(page).to have_content product.description
    expect(page).to have_content product.price
  end
  scenario 'view properties of product' do
    visit product_path(product)

    product_properties.each do |p_property|
      expect(page).to have_content p_property.property.name
      expect(page).to have_content p_property.property_value.value
    end
  end
  scenario 'have put product link' do
    visit product_path(product)

    expect(page).to have_link "put-cart-product-#{product.id}"
  end
end
