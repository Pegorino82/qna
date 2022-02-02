# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  describe 'GET #new' do
    it 'renders new view' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'new user' do
      it 'creates new user' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: 'test@mail.com' }
        end.to change(User, :count).by(1)
      end

      it 'creates authorization' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: 'test@mail.com' }
        end.to change(Authorization, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: { uid: 123, provider: 'vkontakte', email: 'test@mail.com' }
        expect(response).to redirect_to root_path
      end
    end

    context 'existing user' do
      let!(:user) { create :user }

      it 'does not creates new user' do
        expect do
          post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
        end.to_not change(User, :count)
      end

      it 'redirects to root path' do
        post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
        expect(response).to redirect_to root_path
      end

      context 'new authorization' do
        it 'creates authorization' do
          expect do
            post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
          end.to change(Authorization, :count).by(1)
        end
      end

      context 'existing authorization' do
        let!(:authorization) { create :authorization, user: user, confirmation_token: 'qwerty' }

        it 'does not creates authorization' do
          expect do
            post :create, params: { uid: 123, provider: 'vkontakte', email: user.email }
          end.to_not change(Authorization, :count)
        end
      end

      describe 'GET #email_confirmation' do
        let!(:user) { create :user }
        let!(:authorization) { create :authorization, user: user, confirmation_token: 'qwerty' }

        before do
          get :email_confirmation, params: {
            authorization_id: authorization,
            confirmation_token: authorization.confirmation_token }
        end

        it 'accepts token' do
          authorization.reload
          expect(authorization).to be_confirmed
        end

        it 'login user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end

