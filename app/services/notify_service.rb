class NotifyService
  def new_order_notify(object)
    new_order_email_notify(object)
  end

  def new_order_email_notify(object)
    User.where(admin: true).find_each do |admin|
      OrdersMailer.new_order(admin, object).deliver_now
    end
  end
end
