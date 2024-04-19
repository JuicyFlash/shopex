require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  describe 'authenticated user' do
    let!(:user) { create(:user) }
    let!(:product) { create(:product) }
    let!(:cart) { create(:cart, user:) }

    before do
      login(user)
    end
    describe '#put_product' do
      it 'create new cart_product in user`s cart' do
        expect(CartProduct.count).to eq 0
        patch :put_product, params: { product: { product_id: product.id, quantity: 1 } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
      end
      it 'set count from params to cart_product' do
        expect(CartProduct.count).to eq 0
        patch :put_product, params: { product: { product_id: product.id, quantity: 3 } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
        expect(CartProduct.first.quantity).to eq 3
      end
      it 'add count if product already exist' do
        create(:cart_product, cart:, product:, quantity: 1)
        patch :put_product, params: { product: { product_id: product.id, quantity: 3 } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
        expect(CartProduct.first.quantity).to eq 4
      end
    end

    describe 'update(#add#sub)' do
      let!(:cart_product) { create(:cart_product, cart:, product:, quantity: 3) }

      it 'add cart_product product count' do
        patch :add_product, params: { product: { product_id: product.id, quantity: 3 } }, format: :turbo_stream
        cart_product.reload

        expect(cart_product.quantity).to eq 6
      end
      it 'sub cart_product count' do
        patch :sub_product, params: { product: { product_id: product.id, quantity: 2 } }, format: :turbo_stream
        cart_product.reload

        expect(cart_product.quantity).to eq 1
      end
    end

    describe '#show' do
      let!(:cart_product) { create_list(:cart_product, 5, cart:, product:) }
      it 'find actual cart with products' do
        get :show
        crt = assigns(:cart)

        expect(crt).to eq cart
        expect(crt.cart_products).to match_array(cart.cart_products)
      end
    end
  end

  describe 'unauthenticated user' do
    let!(:product) { create(:product) }
    let!(:cart) { create(:cart, nil) }
    let(:cart_service) { CartService.new({ cart_id: cart.id }, nil) }

    before do
      allow(CartService)
        .to receive(:new)
          .and_return(cart_service)
    end
    describe '#put_product' do
      it 'create new cart_product in user`s cart' do
        expect(CartProduct.count).to eq 0
        patch :put_product, params: { product: { product_id: product.id, quantity: 1 } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
      end
      it 'set count from params to cart_product' do
        expect(CartProduct.count).to eq 0
        patch :put_product, params: { product: { product_id: product.id, quantity: 3 } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
        expect(CartProduct.first.quantity).to eq 3
      end
      it 'add count if product already exist' do
        create(:cart_product, cart:, product:, quantity: 1)
        patch :put_product, params: { product: { product_id: product.id, quantity: 3 } }, format: :turbo_stream

        expect(CartProduct.count).to eq 1
        expect(CartProduct.first.quantity).to eq 4
      end
    end

    describe 'update(#add#sub)' do
      let!(:cart_product) { create(:cart_product, cart:, product:, quantity: 3) }

      it 'add cart_product product count' do
        patch :add_product, params: { product: { product_id: product.id, quantity: 3 } }, format: :turbo_stream
        cart_product.reload

        expect(cart_product.quantity).to eq 6
      end
      it 'sub cart_product count' do
        patch :sub_product, params: { product: { product_id: product.id, quantity: 2 } }, format: :turbo_stream
        cart_product.reload

        expect(cart_product.quantity).to eq 1
      end
    end

    describe '#show' do
      let!(:cart_product) { create_list(:cart_product, 5, cart:, product:) }
      it 'find actual cart with products' do
        get :show
        crt = assigns(:cart)

        expect(crt).to eq cart
        expect(crt.cart_products).to match_array(cart.cart_products)
      end
    end
  end
end
