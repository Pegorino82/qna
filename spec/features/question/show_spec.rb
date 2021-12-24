# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question and it answers', "
  In order to view a question
  As an user
  I'd like to be able to see the question and it answers
" do
  given(:user) { create :user }
  given(:question) { create :question, author_id: user.id }
  given!(:answers) { create_list :answer, 3, question: question }

  describe 'Authenticated user' do
    scenario 'can see the question and it answers' do
      sign_in(user)

      visit question_path(question)

      expect(page).to have_content I18n.t('questions.show.header')
      expect(page).to have_content question.title
      expect(page).to have_content question.body

      expect(page).to have_content I18n.t('questions.show.answers')
      expect(page.all('li').count).to eq 3
    end
  end

  scenario 'Unauthenticated user can the question and it answers' do
    visit question_path(question)

    expect(page).to have_content I18n.t('questions.show.header')
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content I18n.t('questions.show.answers')
    expect(page.all('li').count).to eq 3
  end
end