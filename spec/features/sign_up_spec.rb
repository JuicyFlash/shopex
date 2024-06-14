require 'rails_helper'

feature 'User can sign up' do
  given(:user) { create(:user) }

  background do
    visit new_user_registration_path
  end

  describe 'with correct params' do
    scenario 'tries sign up' do
      within '#new_user' do
        fill_in 'user[email]', with: "unregistered_#{user.email}"
        fill_in 'user[password]', with: user.password
        fill_in 'user[password_confirmation]', with: user.password
        click_on I18n.t('user_registration.signup')
      end

      expect(page).to have_content I18n.t('devise.registrations.signed_up')
    end

    scenario 'tries sign up if already registered' do
      within '#new_user' do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        fill_in 'user[password_confirmation]', with: user.password
        click_on I18n.t('user_registration.signup')
      end
      expect(page).to have_content I18n.t('errors.attributes.email.taken')
    end
  end

  describe 'with incorrect params' do
    scenario 'tries sign up with blank email' do
      within '#new_user' do
        fill_in 'user[password]', with: user.password
        fill_in 'user[password_confirmation]', with: user.password
        click_on I18n.t('user_registration.signup')
      end

      expect(page).to have_content I18n.t('errors.messages.blank')
    end

    scenario 'tries sign up with blank password' do
      within '#new_user' do
        fill_in 'user[email]', with: "unregistered_#{user.email}"
        click_on I18n.t('user_registration.signup')
      end

      expect(page).to have_content I18n.t('errors.messages.not_saved')
    end

    scenario 'tries sign up if password less then 6 characters' do
      within '#new_user' do
        fill_in 'user[email]', with: "unregistered_#{user.email}"
        fill_in 'user[password]', with: '12345'
        fill_in 'user[password_confirmation]', with: '12345'
        click_on I18n.t('user_registration.signup')
      end

      expect(page).to have_content I18n.t('errors.attributes.password.too_short')
    end

    scenario 'tries sign up if password different with password confirmation' do
      within '#new_user' do
        fill_in 'user[email]', with: "unregistered_#{user.email}"
        fill_in 'user[password]', with: '1234567'
        fill_in 'user[password_confirmation]', with: '123456'
        click_on I18n.t('user_registration.signup')
      end

      expect(page).to have_content I18n.t('errors.attributes.password_confirmation.confirmation')
    end
  end
end
