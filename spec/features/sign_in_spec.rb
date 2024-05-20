# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in' do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in', js: true do
    within '.email-field' do
      fill_in 'user_email', with: user.email
    end

    within '.password-field' do
      fill_in 'user_password', with: user.password
    end
    within '.login-action' do
      click_on I18n.t('user_sessions.login')
    end

    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'Unregistered user tries to sign in' do
    within '.email-field' do
      fill_in 'user_email', with: 'wrong@test.com'
    end

    within '.password-field' do
      fill_in 'user_password', with: '123456'
    end
    within '.login-action' do
      click_on I18n.t('user_sessions.login')
    end

    within '.new_user' do
      click_on I18n.t('user_sessions.login')
    end

    expect(page).to have_content I18n.t('devise.failure.not_found_in_database')
  end
end
