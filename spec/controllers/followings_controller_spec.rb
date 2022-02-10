# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FollowingsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new following in the database' do
          expect do
            post :create,
                 params: { question_id: question },
                 format: :js
          end.to change(question.followings, :count).by(1)
        end

        it 'renders create template' do
          post :create,
               params: { question_id: question },
               format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the following' do
          expect do
            post :create,
                 params: { question_id: 0 },
                 format: :js
          end.to_not change(Following, :count)
        end

        it 'renders create template' do
          post :create,
               params: { question_id: 0 },
               format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not save a new following in the database' do
        expect do
          post :create,
               params: { question_id: question },
               format: :js
        end.to_not change(question.followings, :count)
      end

      it 'redirects to login page' do
        post :create,
             params: { question_id: question },
             format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy', js: true do
    context 'authenticated user' do
      before { login(user) }
      let!(:following) { create :following, question: question, author: user }

      context 'user is author' do
        it 'deletes the following' do
          expect { delete :destroy, params: { id: following }, format: :js }
            .to change(question.followings, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: following }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'user is not author' do
        let!(:following) { create :following, question: question }

        it 'does not deletes others following' do
          expect { delete :destroy, params: { id: following }, format: :js }
            .to_not change(question.followings, :count)
        end

        it 'returns 401' do
          delete :destroy, params: { id: following }, format: :js
          expect(response.status).to eq 401
        end
      end
    end

    context 'unauthenticated user' do
      let!(:following) { create :following }

      it 'does not delete following' do
        expect do
          delete :destroy, params: { id: following }, format: :js
        end.to_not change(question.followings, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: { id: following }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end
