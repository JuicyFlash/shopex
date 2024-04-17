require 'rails_helper'

feature 'User can view list of products' do

  given!(:products) { create_list(:product, 3) }

  scenario 'view list of products' do
    visit products_path

    expect(page).to have_content products[0].title
    expect(page).to have_content products[1].title
    expect(page).to have_content products[2].title
  end
end
