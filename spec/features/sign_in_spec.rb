# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create :user }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    # save_and_open_page
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path

    fill_in 'Email', with: 'bad@test.com'
    fill_in 'Password', with: 'qwerty'
    click_on I18n.t('devise.sessions.new.log_in')

    expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: 'Email')
  end
end
