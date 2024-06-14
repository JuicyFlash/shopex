require 'rails_helper'

feature 'User can purge product from basket_products' do
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
    scenario 'have purge link' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_link "remove-cart-product-#{cart_product.id}"
      end
    end

    scenario 'remove product' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_content cart_product.product.title
        click_on "remove-cart-product-#{cart_product.id}"
      end

      expect(page).to_not have_content cart_product.product.title
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
    scenario 'have purge link' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_link "remove-cart-product-#{cart_product.id}"
      end
    end

    scenario 'remove product' do
      within "#cart-product-#{cart_product.id}" do
        expect(page).to have_content cart_product.product.title
        click_on "remove-cart-product-#{cart_product.id}"
      end

      expect(page).to_not have_content cart_product.product.title
    end
  end
end
