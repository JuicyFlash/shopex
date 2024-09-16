class OrdersTelegramMailer < ApplicationMailer
  def new_order(user, order)
    @user = user
    @order = order

    send_message
  end

  private

  def send_message
    HTTParty.post(tg_config[:api_url],
                  headers: {
                    'Content-Type' => 'application/json'
                  },
                  body: {
                    parse_mode: tg_config[:parse_mode],
                    chat_id: tg_config[:chat_id],
                    text: make_message
                  }.to_json)
  end

  def tg_config
    @tg_config ||= { api_key: TELEGRAM[:api_key],
                     chat_id: @user,
                     parse_mode: 'MarkdownV2',
                     api_url: "#{TELEGRAM[:api_path]}#{TELEGRAM[:api_key]}/sendMessage" }
  end

  def make_message
    text = "[#{I18n.t('orders_telegram_mailer.subject')} №#{@order.id}](#{orders_url})"
    @order.order_products.find_each do |order_product|
      text = "#{text}  \n#{order_product.product.title} #{order_product.quantity}"
    end
    text
  end

  def orders_url
    admin_orders_url(subdomain: URI(admin_orders_url).host.include?('www.') ? '' : 'www')
  end
end
