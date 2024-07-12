class OrdersMailer < ApplicationMailer
  def new_order(user, order)
    @order = order
    mail to: user.email, subject: I18n.t('orders_mailer.subject')
  end

  def new_order_telegram(user, order)
    api_key = Rails.application.credentials[:telegram][:api_key]
    chat_id = user
    url = URI(admin_orders_url)
    text = "[Оформлен заказ №#{order.id}](#{admin_orders_url(subdomain: url.host.include?('www.') ? '' : 'www')})"
    order.order_products.find_each do |order_product|
      text = "#{text}  \n#{order_product.product.title} #{order_product.quantity}"
    end
    url = "#{TELEGRAM[:api_path]}#{api_key}/sendMessage"
    HTTParty.post(url,
                  headers: {
                    'Content-Type' => 'application/json'
                  },
                  body: {
                    parse_mode: 'MarkdownV2',
                    chat_id:,
                    text:
                  }.to_json)
  end
end
