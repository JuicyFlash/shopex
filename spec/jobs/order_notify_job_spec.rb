require 'rails_helper'

RSpec.describe OrderNotifyJob, type: :job do
  let(:order) { create :order }
  let(:service) { double('NotifyService') }

  before do
    allow(NotifyService).to receive(:new).and_return(service)
  end
  it 'calls Service::NotifyService#new_order_notify' do
    expect(service).to receive(:new_order_notify).with(order)
    OrderNotifyJob.perform_now(order)
  end
end
