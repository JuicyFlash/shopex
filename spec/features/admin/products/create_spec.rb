# frozen_string_literal: true

require 'rails_helper'

feature 'User can create new product' do
  given(:user_admin) { create(:user, admin: true) }
  given!(:user) { create(:user, admin: false) }
  given!(:brand) { create(:brand) }

  describe 'authorized user' do
    background do
      sign_in(user_admin)
      sleep 0.2.second
      visit admin_products_path
    end
    scenario 'have create form', js: true do
      expect(page).to have_content I18n.t('admin.products.index.add_product')

      click_on I18n.t('admin.products.index.add_product')
      within '#new-product-form' do
        expect(page).to have_content I18n.t('admin.products.form.title')
        expect(page).to have_content I18n.t('admin.products.form.description')
        expect(page).to have_content I18n.t('admin.products.form.brand')
        expect(page).to have_content I18n.t('admin.products.form.price')
      end
    end
    scenario 'create product', js: true do
      click_on I18n.t('admin.products.index.add_product')
      within '#new-product-form' do
        fill_in 'product[title]', with: 'Test_title'
        fill_in 'product[description]', with: 'Test_description'
        fill_in 'product[price]', with: '11.0'
        click_on I18n.t('admin.products.form.add_product')
      end

      within '#admin-products' do
        expect(page).to have_content 'Test_title'
        expect(page).to have_content 'Test_description'
        expect(page).to have_content '11.0'
      end
    end
    scenario 'create product with wrong arguments', js: true do
      click_on I18n.t('admin.products.index.add_product')
      within '#new-product-form' do
        fill_in 'product[title]', with: nil
        fill_in 'product[description]', with: 'Test_description'
        fill_in 'product[price]', with: '11.0'
        click_on I18n.t('admin.products.form.add_product')
      end

      within '#new-product-form' do
        I18n.t('errors.messages.blank')
      end
    end
  end

  describe 'not authorized user' do
    scenario 'cant visit admin_products_path' do
      sign_in(user)
      visit admin_products_path

      expect(page).to have_content I18n.t('errors.messages.not_admin')
    end
  end
end
