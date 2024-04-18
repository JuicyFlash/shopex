# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :current_user

  def cart_service
    @cart_service ||= CartService.new(session, current_user)
  end
end
