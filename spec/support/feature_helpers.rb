# frozen_string_literal: true

def sign_in(user)
  visit new_user_session_path
  within '.email-field' do
    fill_in 'user_email', with: user.email
  end

  within '.password-field' do
    fill_in 'user_password', with: user.password
  end
  within '.login-action' do
    click_on I18n.t('user_sessions.login')
  end
end
