# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can create an answer', "
  In order to be able to answer the question
  As an authenticated user
  I'd like to be able to create an answer
" do
  given(:user) { create :user }
  given(:question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'tries create an answer to the question' do
      fill_in 'Body', with: 'Answer body'

      click_on I18n.t('answers.create.submit')

      expect(page).to have_content I18n.t('answers.create.success')
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      expect(page).to have_content I18n.t('questions.show.answers')
      within '.answers' do  # to be sure we are looking for answer in answers
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'tries create an answer with errors to the question' do
      click_on I18n.t('answers.create.submit')

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user can not create an answer to the question' do
    visit question_path(question)

    fill_in 'Body', with: 'Answer body'
    click_on I18n.t('answers.create.submit')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
