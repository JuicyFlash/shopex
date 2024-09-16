# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :current_user, :set_locale

  def cart_service
    @cart_service ||= CartService.new(session, current_user)
  end

  def default_url_options
    I18n.default_locale == I18n.locale ? { lang: nil } : { lang: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = I18n.locale_available?(params[:lang]) ? params[:lang] : I18n.default_locale
  end
end
