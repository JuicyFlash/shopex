# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartService do

  describe 'unauthenticated user' do
    let(:cart) { create(:cart, user: nil) }
    let(:compare_cart) { create(:compare_cart, user: nil) }

    it 'take a new carts if carts not exist' do
      expect(Cart.count).to eq 0
      crt = CartService.new({ cart_id: nil, compare_cart_id: nil  }, nil)

      expect(Cart.count).to eq 2
      expect(crt.cart.id).to eq Cart.first.id
      expect(crt.compare_cart.id).to eq CompareCart.first.id
    end
    it 'find existing carts' do
      crt = CartService.new({ cart_id: cart.id, compare_cart_id: compare_cart.id }, nil)

      expect(crt.cart.id).to eq cart.id
      expect(crt.cart).to be_a Cart
      expect(crt.compare_cart.id).to eq compare_cart.id
      expect(crt.compare_cart).to be_a CompareCart
    end
  end

  describe 'authenticated user' do
    let!(:user) { create(:user) }
    let(:cart) { create(:cart, user: nil) }
    let(:compare_cart) { create(:compare_cart, user: nil) }

    it 'take a new cart for user if suer`s cart not exist' do
      expect(Cart.count).to eq 0
      CartService.new({ cart_id: nil, compare_cart_id: nil }, user)

      expect(Cart.count).to eq 2
    end
    it 'find cart for authenticated user' do
      crt = CartService.new({ cart_id: nil, compare_cart_id: nil  }, user)
      user.reload

      expect(crt.cart.id).to eq user.cart.id
      expect(crt.cart).to be_a Cart
      expect(crt.compare_cart.id).to eq user.compare_cart.id
      expect(crt.compare_cart).to be_a CompareCart
    end
    it 'copy products from unauthenticated user`s cart to current user` cart' do
      @cart_service = CartService.new({ cart_id: cart.id }, nil)
      @cart_products = create_list(:cart_product, 3, cart: @cart_service.cart)

      @user_cart_service = CartService.new({ cart_id: cart.id }, user)
      expect(@cart_products.to_a).to eq @user_cart_service.cart.cart_products.to_a
    end
  end
end
