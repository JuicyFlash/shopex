require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many(:order_products).dependent(:destroy) }
  it { should have_many(:products) }
  it { should belong_to(:user).optional(true) }
  it { should have_one(:detail) }

  describe 'order methods' do
    let!(:order) { create(:order) }
    let!(:product) { create(:product, price: 200.00) }
    let!(:order_product) { create(:order_product, order:, product:, quantity: 5) }
    let(:order_products) { create_list(:order_product, 3, order:, product:, quantity: 3) }

    it 'can calculate products total price #total' do
      total = 0
      order.order_products.find_each do |order_product|
        total += order_product.total_price
      end

      expect(total).to eq order.total
    end

    describe 'notify service' do
      let(:notify_order) { build(:order) }

      it 'calls OrderNotifyJob#perform_later' do
        expect(OrderNotifyJob).to receive(:perform_later).with(notify_order)
        notify_order.save
      end
    end
  end
end
