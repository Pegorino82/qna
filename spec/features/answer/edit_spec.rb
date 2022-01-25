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
  given!(:link) { create :link, linkable: answer }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    context 'is author' do
      background do
        visit question_path(question)

        within '.answers' do
          click_on I18n.t('questions.show.edit_answer')
        end
      end

      scenario 'edit his answer' do
        within '.answers' do
          # to be sure we are looking for answer in answers
          fill_in 'answer[body]', with: 'Edited answer'
          click_button I18n.t('answers.edit.submit')

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Edited answer'
          expect(page).to_not have_selector 'textarea#answer_body'
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

      scenario 'add links when edit his answer' do
        within '.answers' do
          click_on I18n.t('links.new.add')

          fill_in 'Link title', with: 'New link'
          fill_in 'Url', with: 'http://new_link.com'

          click_button I18n.t('answers.edit.submit')

          expect(page).to have_link 'New link'
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

      scenario 'can delete link' do
        within '.answers' do
          find("#answer_#{answer.id}_links").first(:link, I18n.t('links.destroy.delete')).click

          expect(page).to_not have_link link.title
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
      given!(:other_answer_link) { create :link, linkable: other_answer }

      background { visit question_path(other_question) }

      scenario "tries to edit other's answer" do
        expect(page).to_not have_content I18n.t('questions.show.edit_answer')
      end

      scenario "tries to delete other's file" do
        within ".answers div[id='answer_#{other_answer.id}_files']" do
          expect(page).to_not have_link I18n.t('files.destroy.delete')
        end
      end

      scenario "tries to delete other's link" do
        within ".answers div[id='answer_#{other_answer.id}_links']" do
          expect(page).to_not have_link I18n.t('links.destroy.delete')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'Unauthenticated user can not edit answer' do
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'can not delete file' do
      within ".answers div[id='answer_#{answer.id}_files']" do
        expect(page).to_not have_link I18n.t('files.destroy.delete')
      end
    end

    scenario 'can not delete link' do
      within ".answers div[id='answer_#{answer.id}_links']" do
        expect(page).to_not have_link I18n.t('links.destroy.delete')
      end
    end
  end
end
