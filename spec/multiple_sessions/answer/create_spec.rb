# frozen_string_literal: true

require 'rails_helper'

feature 'Authenticated user can create an answer', "
  In order to be able to answer the question
  As an authenticated user
  I'd like to be able to create an answer
" do
  given(:user) { create :user }
  given(:question) { create :question, author: user }

  context 'multiple sessions' do
    scenario "answer appears om other's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Answer body'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on I18n.t('answers.create.submit')

        expect(page).to have_content 'Answer body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
