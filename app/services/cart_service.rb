class CartService

  attr_reader :cart
  attr_reader :compare_cart

  def initialize(session, user)
    @session = session
    @user = user
    @cart = prepare_cart(:cart_id, Cart)
    @compare_cart = prepare_cart(:compare_cart_id, CompareCart)
  end

  def prepare_cart(session_cart_key, cart_type)
    if @user.nil?
      prepare_cart_by_session(session_cart_key, cart_type)
    else
      prepare_cart_by_user(session_cart_key, cart_type)
    end
  end
  private

  def prepare_cart_by_session(session_cart_key, cart_type)
    if @session[session_cart_key].nil? || cart_type.find_by(id: @session[session_cart_key]).nil?
      session_cart = set_new_cart(session_cart_key, cart_type)
    else
      session_cart = cart_type.find_by(id: @session[session_cart_key])
    end

    session_cart
  end

  def prepare_cart_by_user(session_cart_key, cart_type)
    user_cart = cart_type.find_by(type: cart_type.to_s, user_id: @user.id)

    user_cart = cart_type.create(user_id: @user.id) if user_cart.nil?

    if @session[session_cart_key].present? && @session[session_cart_key] != user_cart.id
      user_cart.transaction do
        user_cart.copy_cart_products_from(@session[session_cart_key])
        purge_cart(@session[session_cart_key])
      end
      @session[session_cart_key] = nil
    end

    user_cart
  end

  def purge_cart(purged_cart_id)
    Cart.delete(purged_cart_id)
  end

  def set_new_cart(session_cart_key, cart_type)
    new_cart = cart_type.create
    @session[session_cart_key] = new_cart.id

    new_cart
  end
end
