# frozen_string_literal: true

require 'rails_helper'

feature 'User can create order by cart' do

  describe 'authenticated user' do
    given!(:user) { create(:user) }
    given!(:order) { create(:order, user:) }
    given!(:order_detail) { create(:order_detail, order:) }
    given!(:order_products) { create_list(:order_product, 2, order:, quantity: 2) }

    scenario 'show user`s order' do
      sign_in(user)
      visit orders_path

      expect(page).to have_content order_products.first.product.title
      expect(page).to have_content order_products.last.product.title
    end
  end
end
