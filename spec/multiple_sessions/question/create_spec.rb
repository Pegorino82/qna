# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create :user }

  context 'multiple sessions', js: true do
    scenario "question appears on other user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on I18n.t('questions.index.ask')

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text'
        click_on I18n.t('questions.new.ask')

        expect(page).to have_content I18n.t('questions.create.success')
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
