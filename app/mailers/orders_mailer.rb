class OrdersMailer < ApplicationMailer
  def new_order(user, order)
    @order = order
    mail to: user.email, subject: I18n.t('orders_mailer.subject')
  end
end
