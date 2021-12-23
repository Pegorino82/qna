# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of questions', "
  In order to find a question
  As an user
  I'd like to be able to see all questions
" do
  given!(:questions) { create_list :question, 3 }

  background { visit questions_path }

  describe 'Authenticated user' do
    scenario 'can see a list of all questions' do
      user = create :user

      sign_in(user)

      expect(page.all('tbody tr').count).to eq 3
    end
  end

  scenario 'Unauthenticated user can see a list of questions' do
    expect(page.all('tbody tr').count).to eq 3
  end
end
