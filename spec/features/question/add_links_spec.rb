# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create :user }
  given(:gist_url) { 'https://gist.github.com/Pegorino82/8f318de6098f1db26020d38a809a3b75' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      click_on I18n.t('links.new.add')
    end

    context 'with correct url' do
      background do
        fill_in 'Link title', with: 'My gist'
        fill_in 'Url', with: gist_url
      end

      scenario 'can add link when asks question' do
        click_on I18n.t('questions.new.ask')

        expect(page).to have_link 'My gist', href: gist_url
      end

      scenario 'can add several links when asks question' do
        google_url = 'https://google.com'

        click_on I18n.t('links.new.add')

        within all('.nested_fields').last do
          fill_in 'Link title', with: 'Google'
          fill_in 'Url', with: google_url
        end

        click_on I18n.t('questions.new.ask')

        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'can not add link with bad url' do
      fill_in 'Link title', with: 'My gist'
      fill_in 'Url', with: 'gist_url'

      click_on I18n.t('questions.new.ask')

      expect(page).to_not have_link 'My gist', href: gist_url
      expect(page).to have_content 'Links url is invalid'
    end
  end
end