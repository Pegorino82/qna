# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose best answer for his question', "
  In order to mark best answer for my question
  As an author of question
  I'd like to be able to choose best answer
" do
  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answers) { create_list :answer, 3, question: question, author: user }

  describe 'User is the author of question', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'can choose best answer' do
      best_answer = answers.last

      within ".answers li#answer-#{best_answer.id}" do
        click_on I18n.t('questions.show.mark_best_answer')
      end

      visit question_path(question)
      expect(page).to have_selector("#answer-#{best_answer.id}.best_answer")
    end

    scenario 'can choose another best answer' do
      answers.first.mark_as_best
      new_best_answer = answers.last

      within ".answers li#answer-#{new_best_answer.id}" do
        click_on I18n.t('questions.show.mark_best_answer')
      end

      visit question_path(question)
      expect(page).to have_selector("#answer-#{new_best_answer.id}.best_answer")
    end

    scenario "best answer on the top" do
      best_answer = answers.last

      within ".answers li#answer-#{best_answer.id}" do
        click_on I18n.t('questions.show.mark_best_answer')
      end

      visit question_path(question)

      expect(page).to have_selector(".answers>li#answer-#{best_answer.id}.best_answer")
    end
  end

  scenario 'User is not the author of question' do
    visit question_path(question)

    within '.answers' do
      expect(page.all('.best-answer-link').count).to eq 0
    end
  end
end

