# frozen_string_literal: true

require 'rails_helper'

feature 'User can create award to question', "
  In order to reward users fo their answers
  As an question's author
  I'd like to be able to create award for best answer
" do
  given(:user) { create :user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test body'

      click_on I18n.t('awards.new.add')
    end

    context 'with correct attributes' do
      background do
        fill_in 'Award title', with: 'Best answer'
        attach_file 'Image', "#{Rails.root}/app/assets/images/default_badge.png"
      end

      scenario 'can add award when asks question' do
        click_on I18n.t('questions.new.ask')

        expect(page).to have_content 'Test question'
      end
    end

    context 'with incorrect attributes' do
      background { fill_in 'Award title', with: 'Best answer' }

      scenario 'can not create award with bad image' do
        attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

        click_on I18n.t('questions.new.ask')

        expect(page).to have_content I18n.t('awards.errors.not_image')
      end

      scenario 'can not create award with no image' do
        click_on I18n.t('questions.new.ask')

        expect(page).to have_content I18n.t('awards.errors.not_blank')
      end
    end
  end
end
