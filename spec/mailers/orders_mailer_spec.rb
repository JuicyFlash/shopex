require 'rails_helper'

RSpec.describe OrdersMailer, type: :mailer do
  describe 'new_order' do
    let(:user) { create :user, admin: true }
    let(:order) { create :order }
    let(:order_products) { create_list :order_product, 3, order: }
    let(:mail) { OrdersMailer.new_order(user, order) }

    it 'renders the subject' do
      expect(mail.subject).to eql(I18n.t('orders_mailer.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email'

    it 'assigns order.order_products' do
      order_products.each do |order_product|
        expect(mail.body.encoded).to match(order_product.product.title)
        expect(mail.body.encoded).to match(order_product.quantity.to_s)
        expect(mail.body.encoded).to match((order_product.quantity * order_product.price).to_s)
      end
    end

    it 'renders orders_path' do
      expect(mail.body.encoded).to match(admin_orders_url)
    end
  end
end
