# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in' do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in', js: true do

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within '.new_user' do
      click_on 'Log in'
    end

    expect(page).to have_content 'Signed in successfully'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456'
    within '.new_user' do
      click_on 'Log in'
    end

    expect(page).to have_content 'Invalid Email or password.'
  end
end
