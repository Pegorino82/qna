# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create :user }
  let!(:question) { create :question, author: user }
  let!(:question_link) { create :link, linkable: question }
  let!(:answer) { create :answer, question: question, author: user }
  let!(:answer_link) { create :link, linkable: answer }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'question' do
        context 'user is author' do
          it 'deletes link' do
            expect { delete :destroy, params: { id: question.links.first }, format: :js }
              .to change(question.links, :count).by(-1)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: question.links.first }, format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'user is not author' do
          let(:other_user) { create :user }
          let!(:other_question) { create :question, author: other_user }
          let!(:other_link) { create :link, linkable: other_question }

          it 'does not delete link' do
            expect { delete :destroy, params: { id: other_question.links.first }, format: :js }
              .to_not change(other_question.links, :count)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: other_question.links.first }, format: :js
            expect(response.status).to eq 401
          end
        end
      end

      context 'answer' do
        context 'user is author' do
          it 'deletes link' do
            expect { delete :destroy, params: { id: answer.links.first }, format: :js }
              .to change(answer.links, :count).by(-1)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: answer.links.first }, format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'user is not author' do
          let(:other_user) { create :user }
          let!(:other_answer) { create :answer, question: question, author: other_user }
          let!(:other_answer_link) { create :link, linkable: other_answer }

          it 'does not delete link' do
            expect { delete :destroy, params: { id: other_answer.links.first }, format: :js }
              .to_not change(other_answer.links, :count)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: other_answer.links.first }, format: :js
            expect(response.status).to eq 401
          end
        end
      end
    end

    context 'Unauthenticated user' do
      context 'question' do
        it "can't delete question's link" do
          expect { delete :destroy, params: { id: question.links.first }, format: :js }
            .to_not change(question.links, :count)
        end

        it 'renders destroy' do
          delete :destroy, params: { id: question.links.first }, format: :js
          expect(response).to have_http_status(401)
        end
      end

      context 'answer' do
        it "can't delete answer's link" do
          expect { delete :destroy, params: { id: answer.links.first }, format: :js }
            .to_not change(question.files, :count)
        end

        it 'renders destroy' do
          delete :destroy, params: { id: answer.links.first }, format: :js
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
