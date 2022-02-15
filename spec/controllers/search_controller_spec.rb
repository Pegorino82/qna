# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'GET #search' do
    before { login(user) }

    context 'with valid attributes' do
      it 'populates params' do
        get :search, params: { text: 'test', question: '1', answer: '1', comment: '1', user: '1' }
        # expect(assigns(:search_params)).to eq '{"text"=>"test", "question"=>"1", "answer"=>"1", "comment"=>"1", "user"=>"1"}'
      end

      it 'renders search view'
    end

    context 'with invalid attributes' do
      it 'does not populates params'
      it 'renders search view'
    end
  end
end
