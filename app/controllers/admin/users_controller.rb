# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  def index
    query = User.all
    @pagy, @users = pagy(query, items: 20)
  end
end
