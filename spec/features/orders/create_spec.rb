# frozen_string_literal: true

require 'rails_helper'

feature 'User can create order by cart' do

  describe 'authenticated user' do
    given!(:user) { create(:user) }
    given!(:cart) { create(:cart, user: user) }
    given!(:cart_products) { create_list(:cart_product, 4, cart:) }

    background do
      sign_in(user)
      visit cart_show_path
    end
    scenario 'show create orders fields' do
      within '.order-form' do
        expect(page).to have_field 'order_detail_attributes_first_name'
        expect(page).to have_field 'order_detail_attributes_last_name'
        expect(page).to have_field 'order_detail_attributes_city'
        expect(page).to have_field 'order_detail_attributes_street'
        expect(page).to have_field 'order_detail_attributes_phone_number'
        expect(page).to have_field 'order_detail_attributes_house_number'
        expect(page).to have_button 'create'
      end
    end
    scenario 'can create order' do
      within '.order-form' do
        fill_in :order_detail_attributes_first_name, with: 'Test_name'
        fill_in :order_detail_attributes_last_name, with: 'Test_surname'
        fill_in :order_detail_attributes_city, with: 'Test_city'
        fill_in :order_detail_attributes_street, with: 'Test_street'
        fill_in :order_detail_attributes_phone_number, with: '999-77777'
        fill_in :order_detail_attributes_house_number, with: '9a'
        click_on 'create'
      end

      expect(page).to have_content 'Order created'
    end
  end

  describe 'unauthenticated user' do
    given!(:cart) { create(:cart, user: nil) }
    given!(:cart_products) { create_list(:cart_product, 4, cart:) }
    given!(:cart_service) { CartService.new({ cart_id: cart.id }, nil) }

    background do
      allow(CartService).to receive(:new).and_return(cart_service)
      visit cart_show_path
    end
    scenario 'show create orders fields' do
      within '.order-form' do
        expect(page).to have_field 'order_detail_attributes_first_name'
        expect(page).to have_field 'order_detail_attributes_last_name'
        expect(page).to have_field 'order_detail_attributes_city'
        expect(page).to have_field 'order_detail_attributes_street'
        expect(page).to have_field 'order_detail_attributes_phone_number'
        expect(page).to have_field 'order_detail_attributes_house_number'
        expect(page).to have_button 'create'
      end
    end
    scenario 'can create order' do
      within '.order-form' do
        fill_in :order_detail_attributes_first_name, with: 'Test_name'
        fill_in :order_detail_attributes_last_name, with: 'Test_surname'
        fill_in :order_detail_attributes_city, with: 'Test_city'
        fill_in :order_detail_attributes_street, with: 'Test_street'
        fill_in :order_detail_attributes_phone_number, with: '999-77777'
        fill_in :order_detail_attributes_house_number, with: '9a'
        click_on 'create'
      end

      expect(page).to have_content 'Order created'
    end
  end
end
