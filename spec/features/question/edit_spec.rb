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
    background { sign_in(user) }

    context 'is author', js: true do
      background do
        visit question_path(question)

        click_on I18n.t('questions.show.edit')
      end

      scenario 'edit question' do
        within '.question' do
          fill_in 'Title', with: 'Edited Title'
          fill_in 'Body', with: 'Edited Body'
          click_on I18n.t('questions.edit.submit')

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'add files when edit question' do
        within '.question' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on I18n.t('questions.edit.submit')

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'can delete file' do
        within '.question' do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on I18n.t('questions.edit.submit')

          find('#question_files').first(:link, I18n.t('files.destroy.delete')).click

          expect(page).to_not have_link 'rails_helper.rb'
        end
      end

      scenario 'edit his question with errors' do
        within '.question' do
          fill_in 'Title', with: ''
          click_on I18n.t('questions.edit.submit')

          expect(page).to have_content "Title can't be blank"
        end
      end
    end

    context 'is not author' do
      given!(:other_user) { create :user }
      given!(:other_question) { create :question, author: other_user }

      background { visit question_path(other_question) }
      scenario "tries to edit other's question" do
        within '.question' do
          expect(page).to_not have_link I18n.t('questions.show.edit')
        end
      end

      scenario "tries to delete other's file" do
        file = fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain')
        other_question.files.attach(file)

        within '.question > #question_files' do
          expect(page).to_not have_link I18n.t('files.destroy.delete')
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not edit question' do
      visit question_path(question)

      expect(page).to_not have_link I18n.t('questions.show.edit')
    end

    scenario 'can not delete file' do
      visit question_path(question)

      within '.question > #question_files' do
        expect(page).to_not have_link I18n.t('files.destroy.delete')
      end
    end
  end
end
