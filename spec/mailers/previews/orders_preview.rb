# Preview all emails at http://localhost:3000/rails/mailers/orders
class OrdersPreview < ActionMailer::Preview
  def new_order
    order = Order.first
    user = User.find_by(admin: true)
    OrdersMailer.new_order(user, order)
  end
end
