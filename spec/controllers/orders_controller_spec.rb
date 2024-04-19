require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'POST #create' do
    let!(:order_detail) { build(:order_detail) }
    let(:order_create) do
      post :create, params: { order: { detail_attributes:
                                                            {
                                                              first_name: order_detail.first_name,
                                                              last_name: order_detail.last_name,
                                                              city: order_detail.city,
                                                              phone_number: order_detail.phone_number,
                                                              street: order_detail.street,
                                                              house_number: order_detail.house_number
                                                            } } }
    end
    describe 'authenticated user' do
      let!(:user) { create(:user) }
      let!(:cart) { create(:cart, user:) }
      let!(:cart_products) { create_list(:cart_product, 5, cart:) }

      before do
        login(user)
      end
      it 'create new order' do
        expect { order_create }.to change(Order, :count).by(1)

        %i[first_name last_name city phone_number street house_number].each do |field|
          expect(OrderDetail.first.send(field)).to eq(order_detail.send(field))
        end
      end
      it 'create new order with actual user' do
        order_create

        expect(Order.first.user).to eq user
      end
      it 'create order items from current cart' do
        order_create

        expect(OrderProduct.all.pluck(:product_id)).to match_array(cart_products.pluck(:product_id))
      end
      it 'clear cart products after create order' do
        expect(CartProduct.count).to eq 5
        order_create

        expect(CartProduct.count).to eq 0
      end
      it 'does not create new order with wrong details' do
        expect do
          post :create, params: { order: { detail_attributes:
                                                   {
                                                     first_name: nil,
                                                     last_name: nil,
                                                     city: order_detail.city,
                                                     phone_number: order_detail.phone_number,
                                                     street: order_detail.street,
                                                     house_number: order_detail.house_number
                                                   } } }, format: :turbo_stream
        end.to change(Order, :count).by(0)
      end
    end

    describe 'unauthenticated user' do
      let!(:cart) { create(:cart) }
      let!(:cart_products) { create_list(:cart_product, 5, cart:) }

      let!(:cart_service) { CartService.new({ cart_id: cart.id }, nil) }

      before do
        allow(CartService).to receive(:new).and_return(cart_service)
      end
      it 'create new order' do
        expect { order_create }.to change(Order, :count).by(1)

        %i[first_name last_name city phone_number street house_number].each do |field|
          expect(OrderDetail.first.send(field)).to eq(order_detail.send(field))
        end
      end
      it 'create order items from current basket' do
        order_create

        expect(OrderProduct.all.pluck(:product_id)).to match_array(cart_products.pluck(:product_id))
      end
      it 'clear cart products after create order' do
        expect(CartProduct.count).to eq 5
        order_create

        expect(CartProduct.count).to eq 0
      end
      it 'does not create new order with wrong details' do
        expect do
          post :create, params: { order: { detail_attributes:
                                                   {
                                                     first_name: nil,
                                                     last_name: nil,
                                                     city: order_detail.city,
                                                     phone: order_detail.phone_number,
                                                     street: order_detail.street,
                                                     house: order_detail.house_number
                                                   } } }, format: :turbo_stream
        end.to change(Order, :count).by(0)
      end
    end
  end
end
