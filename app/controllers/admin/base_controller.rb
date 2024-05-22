# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :admin_required!

  private

  def admin_required!
    return if current_user&.admin?

    redirect_to root_path, alert: t('errors.messages.not_admin')
  end
end
