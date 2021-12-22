require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { User.create!(email: 'user@test.com', password: 'qwerty') }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    #  capybara methods below
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # click_button 'Log in'
    click_on 'Log in'
    # click_button t('devise...')

    # save_and_open_page
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'bad@test.com'
    fill_in 'Password', with: 'qwerty'
    click_button 'Log in'

    expect(page).to have_content I18n.t('devise.failure.invalid', authentication_keys: 'Email')
  end
end
