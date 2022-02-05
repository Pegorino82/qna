# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create,
               params: {
                 question_id: question,
                 answer: attributes_for(:answer, question: question)
               },
               format: :js
        end.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create,
             params: {
               question_id: question,
               answer: attributes_for(:answer, question: question)
             },
             format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: {
                 question_id: question,
                 answer: attributes_for(:answer, :invalid, question: question)
               },
               format: :js
        end.to_not change(Answer, :count)
      end
      it 'renders create template' do
        post :create,
             params: {
               question_id: question,
               answer: attributes_for(:answer, :invalid, question: question)
             },
             format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy', js: true do
    before { login(user) }

    context 'user is author' do
      let!(:answer) { create :answer, question: question, author: user }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author' do
      let(:other_user) { create :user }
      let(:other_question) { create :question, author: other_user }
      let!(:other_answer) { create :answer, question: other_question, author: other_user }

      it 'does not delete the answer' do
        expect do
          delete :destroy, params: { id: other_answer }, format: :js
        end.to_not change(other_question.answers, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #update', js: true do
    before { login(user) }

    let!(:answer) { create :answer, question: question, author: user }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update,
              params: { id: answer, answer: { body: 'New body' } },
              format: :js
        answer.reload
        expect(answer.body).to eq 'New body'
      end

      it 'renders update template' do
        patch :update,
              params: { id: answer, answer: { body: 'New body' } },
              format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update,
                params: { id: answer, answer: attributes_for(:answer, :invalid) },
                format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update,
              params: { id: answer, answer: { body: 'New body' } },
              format: :js
        expect(response).to render_template :update
      end
    end

    context "other's answer" do
      let(:other_user) { create :user }
      let(:other_question) { create :question, author: other_user }
      let!(:other_answer) { create :answer, question: other_question, author: other_user }

      it 'does not change answer attributes' do
        expect do
          patch :update,
                params: { id: other_answer, answer: { body: 'Updated body' } },
                format: :js
        end.to_not change(other_answer, :body)
      end

      it 'redirects to question' do
        patch :update,
              params: { id: other_answer, answer: { body: 'Updated body' } },
              format: :js

        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #best_answer', js: true do
    before { login(user) }

    context 'user is author' do
      let!(:answer) { create :answer, question: question, author: user }

      it 'can set best answer' do
        patch :best_answer, params: { id: answer.id }, format: :js
        question.reload

        expect(question.best_answer).to eq answer
      end
    end

    context 'user is not author' do
      let(:other_user) { create :user }
      let!(:other_question) { create :question, author: other_user }
      let!(:answer) { create :answer, question: other_question, author: other_user }

      it "doesn't set best answer" do
        patch :best_answer, params: { id: answer }, format: :js
        other_question.reload

        expect(other_question.best_answer).to_not eq answer
      end
    end
  end
end
