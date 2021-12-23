# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create,
               params: {
                 question_id: question,
                 answer: attributes_for(:answer, question: question)
               }
        end.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create,
             params: {
               question_id: question,
               answer: attributes_for(:answer, question: question)
             }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid, question: question)
          }
        end.to_not change(Answer, :count)
      end
      it 're-renders new view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, :invalid, question: question)
        }
        expect(response).to render_template :new
      end
    end
  end
end
