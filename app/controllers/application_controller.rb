# frozen_string_literal: true
class ApplicationController < ActionController::Base
  before_action :current_user

end
