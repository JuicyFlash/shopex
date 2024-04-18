class CartService

  attr_reader :cart

  def initialize(session, user)
    @session = session
    @user = user
    prepare_cart
  end

  def prepare_cart
    if @user.nil?
      prepare_cart_by_session
    else
      prepare_cart_by_user
    end
  end

  private

  def prepare_cart_by_session
    if @session[:cart_id].nil? || Cart.find_by(id: @session[:cart_id]).nil?
      set_new_cart
    else
      @cart = Cart.find_by(id: @session[:cart_id])
    end
  end

  def prepare_cart_by_user
    @cart = @user.cart

    @cart = Cart.create(user_id: @user.id) if @cart.nil?

    if @session[:cart_id].present? && @session[:cart_id] != @cart.id
      @cart.transaction do
        @cart.copy_cart_products_from(@session[:cart_id])
        purge_cart(@session[:cart_id])
      end
      @session[:cart_id] = nil
    end
  end

  def purge_cart(purged_cart_id)
    Cart.delete(purged_cart_id)
  end

  def set_new_cart
    @cart = Cart.create
    @session[:cart_id] = @cart.id
  end
end
