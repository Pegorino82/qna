require 'rails_helper'

feature 'User can sign up', %q{
  In order to have registered user's abilities
  As an unregistered user
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: 'qwerty'
    fill_in 'Password confirmation', with: 'qwerty'
    click_on I18n.t('devise.registrations.new.sign_up')

    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end

  scenario 'Registered user tries to sign up' do
    user = create :user

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on I18n.t('devise.registrations.new.sign_up')

    expect(page).to have_content I18n.t('errors.messages.not_saved.one', resource: user.class.to_s.downcase)
  end
end
