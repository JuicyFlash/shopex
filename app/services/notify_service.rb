class NotifyService
  def new_order_notify(object)
    new_order_email_notify(object)
    new_order_telegram_notify(object)
  end

  def new_order_email_notify(object)
    User.where(admin: true).find_each do |admin|
      OrdersMailer.new_order(admin, object).deliver_now
    end
  end

  def new_order_telegram_notify(object)
    user = TELEGRAM[:admin_chat].to_s
    OrdersMailer.new_order_telegram(user, object).deliver_now
  end
end
