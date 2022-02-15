# frozen_string_literal: true

require 'rails_helper'

feature 'User can comment answer', "
  In order to discuss answer
  As an authenticated user
  I'd like to be able to comment answer
" do
  given(:user) { create :user }
  given!(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }
  given!(:answer) { create :answer, question: question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can leave a comment to answer' do
      within "#answer_#{answer.id}_comments" do
        fill_in 'Comment', with: 'Comment text'
        click_on I18n.t('comments.new.create')
        expect(page).to have_content 'Comment text'
      end
    end

    scenario "can't leave a comment with errors to answer" do
      within "#answer_#{answer.id}_comments" do
        click_on I18n.t('comments.new.create')
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario "couldn't leave a comment to question" do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_content I18n.t('comments.new.create')
      end
    end
  end
end
