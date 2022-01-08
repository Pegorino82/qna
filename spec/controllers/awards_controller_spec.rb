# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create :user }
  let(:award) { create :award, user: user }
  # let(:question) { create :question, author: user, award: award }
  # let(:answer) { create :answer, author: user, question: question, award: award }

  describe 'GET #index' do
    context 'authenticated user' do
      before do
        login(user)

        get :index
      end

      it 'populates an array of all awards' do
        expect(assigns(:awards)).to match_array(user.awards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'unauthenticated user' do
      before { get :index }

      it 'redirects to login view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
