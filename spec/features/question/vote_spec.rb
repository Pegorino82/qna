# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote question', "
  In order to rate question
  As an authenticated author
  I'd like to be able to vote other's question
" do
  given(:user) { create :user }
  given!(:other_user) { create :user }
  given!(:question) { create :question, author: other_user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    context 'is not author' do
      background do
        visit question_path(question)
      end

      scenario 'can likes question' do
        within '.question' do
          expect(page.find('.vote-count')).to have_content '0'
          find('.vote-up').click
          expect(page.find('.vote-count')).to have_content '1'
        end
      end

      scenario 'can dislikes question' do
        within '.question' do
          expect(page.find('.vote-count')).to have_content '0'
          find('.vote-down').click
          expect(page.find('.vote-count')).to have_content '-1'
        end
      end

      scenario 'can cancel like question' do
        within '.question' do
          expect(page.find('.vote-count')).to have_content '0'
          find('.vote-up').click
          expect(page.find('.vote-count')).to have_content '1'
          find('.vote-down').click
          expect(page.find('.vote-count')).to have_content '0'
        end
      end

      scenario 'can cancel dislike question' do
        within '.question' do
          expect(page.find('.vote-count')).to have_content '0'
          find('.vote-down').click
          expect(page.find('.vote-count')).to have_content '-1'
          find('.vote-up').click
          expect(page.find('.vote-count')).to have_content '0'
        end
      end

      scenario "can't likes question twice" do
        within '.question' do
          expect(page.find('.vote-count')).to have_content '0'
          find('.vote-up').click
          find('.vote-up').click
          expect(page.find('.vote-count')).to have_content '1'
        end
      end

      scenario "can't dislikes question twice" do
        within '.question' do
          expect(page.find('.vote-count')).to have_content '0'
          find('.vote-down').click
          find('.vote-down').click
          expect(page.find('.vote-count')).to have_content '-1'
        end
      end
    end

    context 'is author' do
      background do
        his_question = create :question, author: user
        visit question_path(his_question)
      end
      scenario "couldn't vote his question" do
        within '.question' do
          expect(page).to have_css('a.vote-up.disabled')
          expect(page).to have_css('a.vote-down.disabled')
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end
    scenario "couldn't vote question" do
      within '.question' do
        expect(page).to have_css('a.vote-up.disabled')
        expect(page).to have_css('a.vote-down.disabled')
      end
    end
  end
end
