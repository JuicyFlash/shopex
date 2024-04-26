# frozen_string_literal: true

require 'rails_helper'

feature 'User can view details of selected product' do

  given!(:product) { create(:product) }

  scenario 'view details of product' do
    visit product_path(product)

    expect(page).to have_content product.title
    expect(page).to have_content product.description
  end
end
