# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can delete his answer', "
  In order to be able to delete the answer i created
  As an authenticated user
  I'd like to be able to delete the answer
" do
  given!(:user) { create :user }

  background { sign_in(user) }

  scenario 'Authenticated user can delete his question' do
    question = create :question, author: user
    answers = create_list :answer, 2, question: question, author: user

    visit question_path(question)

    find("[data-answer-id='#{answers.last.id}']").click

    expect(page).to have_content I18n.t('answers.destroy.success')
    expect(page).to have_content I18n.t('questions.show.answers')
    expect(page.all('li').count).to eq 1
  end

  scenario 'Authenticated user can delete others question' do
    other_user = create :user
    others_question = create :question, author: other_user
    other_answers = create_list :answer, 2, question: others_question, author: other_user

    visit question_path(others_question)

    find("[data-answer-id='#{other_answers.last.id}']").click

    expect(page).to have_content I18n.t('answers.destroy.error.other')
  end
end