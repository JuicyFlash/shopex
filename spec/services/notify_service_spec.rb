# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifyService do
  let(:admins) { create_list(:user, 3, admin: true) }
  let(:users) { create_list(:user, 3) }
  let(:order) { create(:order) }

  it 'send email notify to admins about new order' do
    admins.each { |admin| expect(OrdersMailer).to receive(:new_order).with(admin, order).and_call_original }
    subject.new_order_email_notify(order)
  end

  it 'send telegram notify to admins chat about new order' do
    expect(OrdersTelegramMailer).to receive(:new_order).with(TELEGRAM[:admin_chat], order).and_call_original
    subject.new_order_telegram_notify(order)
  end
end
