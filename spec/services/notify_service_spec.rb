# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyService do
  let(:admins) { create_list(:user, 3, admin: true) }
  let(:users) { create_list(:user, 3) }
  let(:order) { create(:order) }

  it 'send notify to admins about new order' do
    admins.each { |admin| expect(OrdersMailer).to receive(:new_order).with(admin, order).and_call_original }
    subject.new_order_notify(order)
  end
end
