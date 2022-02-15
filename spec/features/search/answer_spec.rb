# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search answers', "
  In order to be able to find answers
  As an common user
  I'd like to be able to full text search in answers
" do
  given!(:answer) { create :answer }

  scenario 'find answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: answer.body
        choose 'Answer'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to have_content answer.body.truncate(10)
        end
      end
    end
  end

  scenario 'does not find answer', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: '123'
        choose 'Answer'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to_not have_content answer.body.truncate(10)
          expect(page).to have_content I18n.t('search.not_found')
        end
      end
    end
  end
end
