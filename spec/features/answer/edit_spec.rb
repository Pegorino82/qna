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
    background { sign_in(user) }

    context 'is author' do
      background do
        visit question_path(question)

        click_on I18n.t('questions.show.edit_answer')
      end

      scenario 'edit his answer' do
        within '.answers' do
          # to be sure we are looking for answer in answers
          fill_in 'Body', with: 'Edited answer'
          click_button I18n.t('answers.edit.submit')

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'add files when edit his answer' do
        within '.answers' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_button I18n.t('answers.edit.submit')

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'can delete file' do
        within '.answers' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on I18n.t('answers.edit.submit')

          find("#answer_#{answer.id}_files").first(:link, I18n.t('files.destroy.delete')).click

          expect(page).to_not have_link 'rails_helper.rb'
        end
      end

      scenario 'edit his answer with errors' do
        within '.answers' do
          # to be sure we are looking for answer in answers
          fill_in 'Body', with: ''
          click_button I18n.t('answers.edit.submit')

          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    context 'is not author' do
      given!(:other_user) { create :user }
      given!(:other_question) { create :question, author: other_user }
      given!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
      given!(:other_answer) { create :answer, question: other_question, author: other_user, files: [file] }

      background { visit question_path(other_question) }

      scenario "tries to edit other's answer" do
        expect(page).to_not have_content I18n.t('questions.show.edit_answer')
      end

      scenario "tries to delete other's file" do
        within ".answers div[id^='answer']" do
          expect(page).to_not have_link I18n.t('files.destroy.delete')
        end
      end
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
