# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create :user }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to create question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text'
      click_on I18n.t('questions.new.ask')

      expect(page).to have_content I18n.t('questions.create.success')
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text'
    end

    scenario 'tries to create question with errors' do
      click_on I18n.t('questions.new.ask')

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
