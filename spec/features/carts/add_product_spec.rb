require 'rails_helper'

feature 'User can add product in cart' do
  describe 'authenticated user' do
    given!(:user) { create(:user) }
    given!(:cart) { create(:cart, user:) }
    given!(:product) { create(:product) }
    given!(:cart_product) { create(:cart_product, cart:, product:, quantity: 1) }

    background do
      sign_in(user)
      sleep 0.2.second
      visit cart_show_path
    end
    scenario 'have add link' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_link "add-cart-product-#{cart_product.id}"
      end
    end

    scenario 'add product', js: true do
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity
        end
        click_link "add-cart-product-#{cart_product.id}"
      end
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity + 1
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
      allow(CartService).to receive(:new).and_return(cart_service)
      visit cart_show_path
    end
    scenario 'have add link' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_link "add-cart-product-#{cart_product.id}"
      end
    end

    scenario 'add product', js: true do
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity
        end
        click_on "add-cart-product-#{cart_product.id}"
      end
      within "#cart-product-#{cart_product.id}" do
        within '.quantity' do
          expect(page).to have_content cart_product.quantity + 1
          expect(page).to_not have_content cart_product.quantity
        end
      end
    end
  end
end
