# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartService do

  describe 'unauthenticated user' do
    let(:cart) { create(:cart, user: nil) }

    it 'take a new cart if cart not exist' do
      expect(Cart.count).to eq 0
      crt = CartService.new({ cart_id: nil }, nil)

      expect(Cart.count).to eq 1
      expect(crt.cart.id).to eq Cart.first.id
    end
    it 'find existing cart' do
      crt = CartService.new({ cart_id: cart.id }, nil)

      expect(crt.cart.id).to eq cart.id
    end
  end

  describe 'unauthenticated user' do
    let!(:user) { create(:user) }
    let(:cart) { create(:cart, user: nil) }

    it 'take a new cart for user if suer`s cart not exist' do
      expect(Cart.count).to eq 0
      CartService.new({ cart_id: nil }, user)

      expect(Cart.count).to eq 1
    end
    it 'find cart for authenticated user' do
      crt = CartService.new({ cart_id: nil }, user)
      user.reload

      expect(crt.cart.id).to eq user.cart.id
    end
    it 'copy products from unauthenticated user`s cart to current user` cart' do
      @cart_service = CartService.new({ cart_id: cart.id }, nil)
      @cart_products = create_list(:cart_product, 3, cart: @cart_service.cart)

      @user_cart_service = CartService.new({ cart_id: cart.id }, user)
      expect(@cart_products.to_a).to eq @user_cart_service.cart.cart_products.to_a
    end
  end
end
