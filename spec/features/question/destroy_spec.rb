# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can delete his question', "
  In order to be able to delete the question i created
  As an authenticated user
  I'd like to be able to delete the question i created
" do
  given!(:user) { create :user }
  given(:question) { create :question, author: user }

  background { sign_in(user) }

  scenario 'Authenticated user can delete his question' do
    visit question_path(question)

    click_on I18n.t('questions.show.delete')

    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user can not delete others question' do
    other_user = create :user
    others_question = create :question, author: other_user

    visit question_path(others_question)

    expect(page).to_not have_content I18n.t('questions.show.delete')
  end
end
