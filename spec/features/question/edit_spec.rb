# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can edit his question', "
  In order to correct the question
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create :user }
  given!(:question) { create :question, author: user }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edit his question', js: true do
      click_on I18n.t('questions.show.edit_answer')

      within '.question' do
        fill_in 'Title', with: 'Edited Title'
        fill_in 'Body', with: 'Edited Body'
        click_on I18n.t('answers.edit.submit')

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'add files when edit his question', js: true do
      click_on I18n.t('questions.show.edit_answer')

      within '.question' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on I18n.t('answers.edit.submit')

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edit his answer with errors', js: true do
      click_on I18n.t('questions.show.edit_answer')

      within '.question' do
        fill_in 'Title', with: ''
        click_on I18n.t('answers.edit.submit')

        expect(page).to have_content "Title can't be blank"
      end
    end

    scenario "tries to edit other's answer" do
      other_user = create :user
      other_question = create :question, author: other_user

      visit question_path(other_question)

      within '.question' do
        expect(page).to_not have_link I18n.t('questions.show.edit_answer')
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
