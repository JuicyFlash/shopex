# frozen_string_literal: true

require 'rails_helper'

feature 'User can create order by cart' do
  describe 'authenticated user' do
    given!(:user) { create(:user) }
    given!(:cart) { create(:cart, user:) }
    given!(:cart_products) { create_list(:cart_product, 4, cart:) }

    background do
      sign_in(user)
      visit cart_show_path
    end
    scenario 'show create orders fields' do
      within '.new-order' do
        expect(page).to have_field 'order[detail_attributes][first_name]'
        expect(page).to have_field 'order[detail_attributes][last_name]'
        expect(page).to have_field 'order[detail_attributes][city]'
        expect(page).to have_field 'order[detail_attributes][street]'
        expect(page).to have_field 'order[detail_attributes][phone_number]'
        expect(page).to have_field 'order[detail_attributes][house_number]'
        expect(page).to have_button 'create'
      end
    end
    scenario 'can create order' do
      within '.new-order' do
        fill_in 'order[detail_attributes][first_name]', with: 'Test_name'
        fill_in 'order[detail_attributes][last_name]', with: 'Test_surname'
        fill_in 'order[detail_attributes][city]', with: 'Test_city'
        fill_in 'order[detail_attributes][street]', with: 'Test_street'
        fill_in 'order[detail_attributes][phone_number]', with: '999-77777'
        fill_in 'order[detail_attributes][house_number]', with: '9a'
        click_on 'create'
      end

      expect(page).to have_content I18n.t('orders.create.create_note')
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
      within '.new-order' do
        expect(page).to have_field 'order[detail_attributes][first_name]'
        expect(page).to have_field 'order[detail_attributes][last_name]'
        expect(page).to have_field 'order[detail_attributes][city]'
        expect(page).to have_field 'order[detail_attributes][street]'
        expect(page).to have_field 'order[detail_attributes][phone_number]'
        expect(page).to have_field 'order[detail_attributes][house_number]'
        expect(page).to have_button 'create'
      end
    end
    scenario 'can create order' do
      within '.new-order' do
        fill_in 'order[detail_attributes][first_name]', with: 'Test_name'
        fill_in 'order[detail_attributes][last_name]', with: 'Test_surname'
        fill_in 'order[detail_attributes][city]', with: 'Test_city'
        fill_in 'order[detail_attributes][street]', with: 'Test_street'
        fill_in 'order[detail_attributes][phone_number]', with: '999-77777'
        fill_in 'order[detail_attributes][house_number]', with: '9a'
        click_on 'create'
      end

      expect(page).to have_content I18n.t('orders.create.create_note')
    end
  end
end
