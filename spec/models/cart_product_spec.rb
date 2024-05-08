# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  describe 'cart_product methods' do
    let!(:product) { create(:product, price: 200.00) }
    let!(:cart_product) { create(:cart_product, product:, quantity: 5) }

    it 'can calculate the total price #total_price' do
      price = product.price * cart_product.quantity

      expect(cart_product.total_price).to eq(price)
    end
  end
end
