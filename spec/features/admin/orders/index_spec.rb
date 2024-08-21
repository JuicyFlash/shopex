# frozen_string_literal: true

require 'rails_helper'

feature 'Admin can view list of all orders' do
  given!(:user_admin) { create(:user, admin: true) }
  given!(:user) { create(:user, admin: false) }
  given!(:orders) { create_list(:order, 3) }

  scenario 'authorized user' do
    orders.each do |order|
      create(:order_detail, order:)
    end
    sign_in(user_admin)
    visit admin_orders_path

    expect(page).to have_content orders[0].author
    expect(page).to have_content orders[1].author
    expect(page).to have_content orders[2].author
  end

  scenario 'not authorized user' do
    sign_in(user)
    visit admin_orders_path

    expect(page).to have_content I18n.t('errors.messages.not_admin')
  end
end
