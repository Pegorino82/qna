# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create :user }
  given(:gist_url) { 'https://gist.github.com/Pegorino82/8f318de6098f1db26020d38a809a3b75' }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit new_question_path
    end

    scenario 'can add link when asks question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      fill_in 'Link title', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on I18n.t('questions.new.ask')

      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end