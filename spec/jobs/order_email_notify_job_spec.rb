require 'rails_helper'

RSpec.describe OrderEmailNotifyJob, type: :job do
  let(:order) { create :order }
  let(:service) { double('NotifyService') }

  before do
    allow(NotifyService).to receive(:new).and_return(service)
  end
  it 'calls Service::NotifyService#new_order_email_notify' do
    expect(service).to receive(:new_order_email_notify).with(order)
    OrderEmailNotifyJob.perform_now(order)
  end
end
