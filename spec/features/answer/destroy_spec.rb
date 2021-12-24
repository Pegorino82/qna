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
    answer = create :answer, question: question, author: user

    visit question_path(question)

    click_on I18n.t('questions.show.delete_answer')

    expect(page).to have_content I18n.t('answers.destroy.success')
    expect(page).to have_content I18n.t('questions.show.answers')
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user can delete others question' do
    other_user = create :user
    others_question = create :question, author: other_user
    create :answer, question: others_question, author: other_user

    visit question_path(others_question)

    expect(page).to_not have_content I18n.t('questions.show.delete_answer')
  end
end