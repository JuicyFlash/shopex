require 'rails_helper'

feature 'User can put out product from cart_products' do

  describe 'authenticated user' do
    given!(:user) { create(:user) }
    given!(:cart) { create(:cart, user:) }
    given!(:cart_product) { create(:cart_product, cart:) }

    background do
      sign_in(user)
      cart_product.quantity = 3
      cart_product.save
      visit cart_show_path
    end
    scenario 'have sub link' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_link 'sub'
      end
    end
    scenario 'sub product', js: true do
      visit cart_show_path
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity
        end
        click_on 'sub'
      end
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity - 1
          expect(page).to_not have_content cart_product.quantity
        end
      end
    end
  end

  describe 'unauthenticated user' do
    given!(:cart) { create(:cart, user: nil) }
    given!(:cart_product) { create(:cart_product, cart:) }
    given!(:cart_service) { CartService.new({ cart_id: cart.id }, nil) }

    background do
      cart_product.quantity = 3
      cart_product.save
      allow(CartService).to receive(:new).and_return(cart_service)
      visit cart_show_path
    end
    scenario 'have sub link' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_link 'sub'
      end
    end
    scenario 'sub product', js: true do
      visit cart_show_path
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity
        end
        click_on 'sub'
      end
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity - 1
          expect(page).to_not have_content cart_product.quantity
        end
      end
    end
  end
end
