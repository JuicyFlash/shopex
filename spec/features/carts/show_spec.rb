# frozen_string_literal: true

require 'rails_helper'

feature 'User can view cart with products' do

  describe 'authenticated user' do
    given!(:user) { create(:user) }
    given!(:cart) { create(:cart, user: user) }
    given!(:cart_products) { create_list(:cart_product, 4, cart: cart) }

    scenario 'show products in cart' do
      sign_in(user)
      visit cart_show_path
      cart_products.each do |cart_product|
        within "#cart-product-#{cart_product.product.id}" do
          expect(page).to have_content cart_product.product.title
          expect(page).to have_content cart_product.quantity
        end
      end
    end
  end

  describe 'unauthenticated user' do
    given!(:cart) { create(:cart, user: nil) }
    given!(:cart_products) { create_list(:cart_product, 4, cart: cart) }
    given!(:cart_service) { CartService.new({ cart_id: cart.id }, nil) }

    scenario 'show products in cart' do
      allow(CartService).to receive(:new).and_return(cart_service)

      visit cart_show_path
      cart_products.each do |cart_product|
        within "#cart-product-#{cart_product.product.id}" do
          expect(page).to have_content cart_product.product.title
          expect(page).to have_content cart_product.quantity
        end
      end
    end
  end
end
