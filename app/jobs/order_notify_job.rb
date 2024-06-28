class OrderNotifyJob < ApplicationJob
  queue_as :default

  def perform(object)
    NotifyService.new.new_order_notify(object)
  end
end
