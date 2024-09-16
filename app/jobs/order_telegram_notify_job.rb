class OrderTelegramNotifyJob < ApplicationJob
  queue_as :default

  def perform(object)
    NotifyService.new.new_order_telegram_notify(object)
  end
end
