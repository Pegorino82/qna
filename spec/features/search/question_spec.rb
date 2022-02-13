require 'sphinx_helper'

feature 'User can search questions', "
  In order to be able to find questions
  As an common user
  I'd like to be able to full text search in questions
" do
  given!(:question) { create :question }

  scenario 'find question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: question.body
        choose 'Question'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to have_content question.body.truncate(10)
        end
      end
    end
  end

  scenario 'does not find question', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: '123'
        choose 'Question'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to_not have_content question.body.truncate(10)
          expect(page).to have_content I18n.t('search.not_found')
        end
      end
    end
  end
end
