# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can edit his answer', "
  In order to correct the answer
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edit his answer' do
      click_on I18n.t('questions.show.edit_answer')

      within '.answers' do  # to be sure we are looking for answer in answers
        fill_in 'Body', with: 'Edited answer'
        click_button I18n.t('answers.edit.submit')

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      within '.answers' do  # to be sure we are looking for answer in answers
        click_on I18n.t('questions.show.edit_answer')

        fill_in 'Body', with: ''

        click_button I18n.t('answers.edit.submit')

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other's answer" do
      other_user = create :user
      other_question = create :question, author: other_user
      create :answer, question: other_question, author: other_user

      visit question_path(other_question)

      expect(page).to_not have_content I18n.t('questions.show.edit_answer')
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end