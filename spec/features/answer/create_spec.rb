# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can create an answer', "
  In order to be able to answer the question
  As an authenticated user
  I'd like to be able to create an answer
" do
  given(:question) { create :question }

  scenario 'Authenticated user can create an answer to the question' do
    user = create :user

    sign_in(user)

    visit question_path(question)

    answers_count = question.answers.count

    fill_in 'Body', with: 'Answer body'
    click_on I18n.t('answers.create.submit')

    expect(page).to have_content I18n.t('answers.create.success')
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_content I18n.t('questions.show.answers')
    expect(page.all('li').count).to eq answers_count + 1
  end

  scenario 'Unauthenticated user can create an answer to the question' do
    visit question_path(question)

    fill_in 'Body', with: 'Answer body'
    click_on I18n.t('answers.create.submit')

    expect(page).to have_content I18n.t('devise.failure.unauthenticated')
  end
end
