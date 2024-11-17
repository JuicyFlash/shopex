require 'rails_helper'

RSpec.describe CompareCartsController, type: :controller do
  describe 'authenticated user' do
    let!(:user) { create(:user) }
    let!(:product) { create(:product) }
    let!(:compare_cart) { create(:compare_cart, user:) }

    before do
      login(user)
    end
    describe '#product_to_compare' do
      it 'create new cart_product in user`s compare_cart' do
        expect(CartProduct.count).to eq 0
        patch :product_to_compare, params: { product: { product_id: product.id } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
      end
      it 'it delete cart_product in user`s compare_cart if product already exist in cart' do
        create(:cart_product, cart: compare_cart, product:)
        patch :product_to_compare, params: { product: { product_id: product.id } }, format: :turbo_stream

        expect(CartProduct.count).to eq 0
      end
    end
    describe '#show' do
      let!(:cart_product) { create_list(:cart_product, 5, cart: compare_cart) }
      it 'find actual cart with products' do
        get :show
        crt = assigns(:compare_cart)

        expect(crt).to eq compare_cart
        expect(crt.cart_products).to match_array(compare_cart.cart_products)
      end
    end
  end

  describe 'unauthenticated user' do
    let!(:product) { create(:product) }
    let!(:compare_cart) { create(:compare_cart, user: nil) }
    let(:cart_service) { CartService.new({ cart_id: nil, compare_cart_id: compare_cart.id }, nil) }

    before do
      allow(CartService)
        .to receive(:new)
              .and_return(cart_service)
    end
    describe '#product_to_compare' do
      it 'create new cart_product in user`s compare_cart' do
        expect(CartProduct.count).to eq 0
        patch :product_to_compare, params: { product: { product_id: product.id } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
      end
      it 'it delete cart_product in user`s compare_cart if product already exist in cart' do
        create(:cart_product, cart: compare_cart, product:)
        patch :product_to_compare, params: { product: { product_id: product.id } }, format: :turbo_stream

        expect(CartProduct.count).to eq 0
      end
    end
    describe '#show' do
      let!(:cart_product) { create_list(:cart_product, 5, cart: compare_cart) }
      it 'find actual cart with products' do
        get :show
        crt = assigns(:compare_cart)

        expect(crt).to eq compare_cart
        expect(crt.cart_products).to match_array(compare_cart.cart_products)
      end
    end
  end
end
