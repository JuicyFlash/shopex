# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of products' do
  given!(:user_admin) { create(:user, admin: true) }
  given!(:user) { create(:user, admin: false) }
  given!(:products) { create_list(:product, 3) }

  scenario 'authorized user' do
    sign_in(user_admin)
    visit admin_products_path

    expect(page).to have_content products[0].title.capitalize
    expect(page).to have_content products[1].title.capitalize
    expect(page).to have_content products[2].title.capitalize
  end

  scenario 'not authorized user' do
    sign_in(user)
    visit admin_products_path

    expect(page).to have_content I18n.t('errors.messages.not_admin')
  end
end
