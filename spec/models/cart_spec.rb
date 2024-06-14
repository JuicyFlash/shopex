require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { should have_many(:cart_products).dependent(:destroy) }
  it { should have_many(:products) }

  describe 'cart methods' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product, price: 200.00) }
    let!(:cart_product) { create(:cart_product, cart:, product:, quantity: 5) }
    let(:cart_products) { create_list(:cart_product, 3, cart:, product:, quantity: 3) }

    it 'can check product #product_exist_in_cart?' do
      expect(cart.product_exist_in_cart?(product.id)).to eq true
    end
    it 'can calculate products count #products_count' do
      create_list(:cart_product, 4, cart:, quantity: 2)
      expect(cart.products_count).to eq 13
    end
    it 'can calculate products total price #total' do
      total = 0
      cart.cart_products.find_each do |cart_product|
        total += cart_product.total_price
      end

      expect(total).to eq cart.total
    end
  end
end
