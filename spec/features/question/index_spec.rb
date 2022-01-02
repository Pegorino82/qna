# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of questions', "
  In order to find a question
  As an user
  I'd like to be able to see all questions
" do
  given(:user) { create :user }
  given!(:questions) { create_list :question, 3, author: user }

  background { visit questions_path }

  describe 'Authenticated user' do
    scenario 'can see a list of all questions' do
      sign_in(user)

      expect(page.all('.question-item').count).to eq 3
    end
  end

  scenario 'Unauthenticated user can see a list of questions' do
    expect(page.all('.question-item').count).to eq 3
  end
end
