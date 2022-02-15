# frozen_string_literal: true

require 'sphinx_helper'

feature 'User can search comments', "
  In order to be able to find comments
  As an common user
  I'd like to be able to full text search in comments
" do
  given!(:question) { create :question }
  given!(:comment) { create :comment, commentable: question }

  scenario 'find comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: comment.body
        choose 'Comment'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to have_content comment.body.truncate(10)
        end
      end
    end
  end

  scenario 'does not find comment', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: '123'
        choose 'Comment'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to_not have_content comment.body.truncate(10)
          expect(page).to have_content I18n.t('search.not_found')
        end
      end
    end
  end
end
