# frozen_string_literal: true

require 'rails_helper'

feature 'User can create new product' do
  given(:user_admin) { create(:user, admin: true) }
  given!(:user) { create(:user, admin: false) }
  given!(:brand) { create(:brand) }
  given!(:product) { create(:product) }

  describe 'authorized user' do
    background do
      sign_in(user_admin)
      sleep 0.2.second
      visit admin_products_path
    end
    scenario 'have update form', js: true do
      within '#admin-products' do
        expect(page).to have_css("a[href='#{edit_admin_product_path(product)}']")
        find(:css, "a[href='#{edit_admin_product_path(product)}']").click
      end

      within '#new-product-form' do
        expect(page).to have_content I18n.t('admin.products.form.title')
        expect(page).to have_content I18n.t('admin.products.form.description')
        expect(page).to have_content I18n.t('admin.products.form.brand')
        expect(page).to have_content I18n.t('admin.products.form.price')
      end
    end

    scenario 'update product', js: true do
      find(:css, "a[href='#{edit_admin_product_path(product)}']").click
      within '#new-product-form' do
        fill_in 'product[title]', with: 'Test_title'
        fill_in 'product[description]', with: 'Test_description'
        fill_in 'product[price]', with: '11.0'
        attach_file 'product[images][]',
                    ["#{Rails.root}/db/seeds/watches_images/speedmaster1.png",
                     "#{Rails.root}/db/seeds/watches_images/speedmaster2.png"]
        click_on I18n.t('admin.products.form.update_product')
      end

      within '#admin-products' do
        expect(page).to have_content 'Test_title'
        expect(page).to have_content 'Test_description'
        expect(page).to have_content '11.0'
      end

      within '#new-product-form' do
        expect(page).to have_css("img[src*='speedmaster1.png']")
        expect(page).to have_css("img[src*='speedmaster2.png']")
      end
    end

    scenario 'create product with wrong arguments', js: true do
      find(:css, "a[href='#{edit_admin_product_path(product)}']").click
      within '#new-product-form' do
        fill_in 'product[title]', with: nil
        fill_in 'product[description]', with: 'Test_description'
        fill_in 'product[price]', with: '11.0'
        click_on I18n.t('admin.products.form.update_product')
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
