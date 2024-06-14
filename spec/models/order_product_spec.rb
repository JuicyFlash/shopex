require 'rails_helper'

RSpec.describe OrderProduct, type: :model do
  it { should belong_to(:order).optional }
  it { should belong_to(:product) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }

  describe 'order_product methods' do
    let!(:product) { create(:product, price: 200.00) }
    let!(:order_product) { create(:order_product, product:, quantity: 5, price: product.price) }

    it 'can calculate the total price #total_price' do
      price = product.price * order_product.quantity

      expect(order_product.total_price).to eq(price)
    end
  end
end
