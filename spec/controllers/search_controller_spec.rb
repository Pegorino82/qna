# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'GET #search' do
    before { login(user) }

    context 'with valid attributes' do
      before { get :search, params: { text: 'test', question: '1', answer: '1', comment: '1', user: '1' } }

      it 'populates params' do
        search_params = {"text"=>"test", "question"=>"1", "answer"=>"1",
                         "comment"=>"1", "user"=>"1", "action"=>"search", "controller"=>"search"}
        expect(assigns(:search_params)).to eq search_params
      end

      it 'renders search view' do
        expect(response).to render_template 'search/_result'
      end
    end

    context 'with invalid attributes' do
      before { get :search, params: { text: '', question: '1', answer: '1', comment: '1', user: '1' } }

      it 'does not populates params' do
        expect(assigns(:results)).to_not be
      end
      it 'renders search view' do
        expect(response).to render_template 'search/_result'
      end
    end
  end
end
