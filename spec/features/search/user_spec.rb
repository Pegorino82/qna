require 'sphinx_helper'

feature 'User can search user', "
  In order to be able to find user
  As an common user
  I'd like to be able to full text search in users
" do
  given!(:user) { create :user }

  scenario 'find user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: user.email
        choose 'User'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to have_content user.email
        end
      end
    end
  end

  scenario 'does not find user', sphinx: true, js: true do
    visit root_path

    ThinkingSphinx::Test.run do
      within '.full-search form' do
        fill_in 'text', with: 'xxx'
        choose 'User'

        find('#search-button').click

        within '.full-search-result' do
          expect(page).to_not have_content user.email
          expect(page).to have_content I18n.t('search.not_found')
        end
      end
    end
  end
end
