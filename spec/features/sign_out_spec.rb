# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  As an unauthenticated user
  I'd like to be able to sign out
" do
  given(:user) { create :user }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)

    click_on I18n.t('main_nav.sign_out')

    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end
end
