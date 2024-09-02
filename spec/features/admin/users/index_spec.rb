# frozen_string_literal: true

require 'rails_helper'

feature 'Admin can view list of all users' do
  given!(:user_admin) { create(:user, admin: true) }
  given!(:user) { create(:user, admin: false) }

  scenario 'authorized user' do
    sign_in(user_admin)
    visit admin_users_path

    expect(page).to have_content user_admin.email
    expect(page).to have_content user.email
  end

  scenario 'not authorized user' do
    sign_in(user)
    visit admin_users_path

    expect(page).to have_content I18n.t('errors.messages.not_admin')
  end
end
