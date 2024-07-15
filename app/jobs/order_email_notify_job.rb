class OrderEmailNotifyJob < ApplicationJob
  queue_as :default

  def perform(object)
    NotifyService.new.new_order_email_notify(object)
  end
end
