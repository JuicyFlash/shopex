require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { should have_many(:cart_products).dependent(:destroy) }
  it { should have_many(:products) }

  describe 'basket_products methods' do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    let!(:cart_product) { create(:cart_product, cart: cart, product: product, quantity: 5) }

    it 'can check product' do
      expect(cart.product_exist_in_cart?(product.id)).to eq true
    end
    it 'can calculate products count' do
      create_list(:cart_product, 4, cart: cart, quantity: 2)
      expect(cart.products_count).to eq 13
    end
  end
end
