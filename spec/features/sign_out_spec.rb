# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign out' do
    sign_in(user)
    visit(root_path)
    click_on I18n.t('user_sessions.logout')

    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end
end
