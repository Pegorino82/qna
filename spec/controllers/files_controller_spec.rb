# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:user) { create :user }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let!(:question) { create :question, author: user, files: [file] }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'question' do
        context 'user is author' do
          it 'deletes file' do
            expect { delete :destroy, params: { id: question.files.first }, format: :js }
              .to change(question.files, :count).by(-1)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: question.files.first }, format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'user is not author' do
          let(:other_user) { create :user }
          let!(:other_question) { create :question, author: other_user, files: [file] }

          it 'does not delete file' do
            other_question.files.attach(file)

            expect { delete :destroy, params: { id: other_question.files.first }, format: :js }
              .to_not change(other_question.files, :count)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: other_question.files.first }, format: :js
            expect(response).to render_template :destroy
          end
        end
      end

      context 'answer' do
        context 'user is author' do
          let!(:answer) { create :answer, question: question, author: user, files: [file] }

          it 'deletes file' do
            expect { delete :destroy, params: { id: answer.files.first }, format: :js }
              .to change(answer.files, :count).by(-1)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: answer.files.first }, format: :js
            expect(response).to render_template :destroy
          end
        end

        context 'user is not author' do
          let(:other_user) { create :user }
          let!(:other_answer) { create :answer, question: question, author: other_user, files: [file] }

          it 'does not delete file' do
            other_answer.files.attach(file)

            expect { delete :destroy, params: { id: other_answer.files.first }, format: :js }
              .to_not change(other_answer.files, :count)
          end

          it 'renders destroy' do
            delete :destroy, params: { id: other_answer.files.first }, format: :js
            expect(response).to render_template :destroy
          end
        end
      end
    end

    context 'Unauthenticated user' do
      context 'question' do
        it "can't delete question's file" do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }
            .to_not change(question.files, :count)
        end

        it 'renders destroy' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to have_http_status(401)
        end
      end

      context 'answer' do
        let!(:answer) { create :answer, question: question, author: user, files: [file] }

        it "can't delete question's file" do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }
            .to_not change(question.files, :count)
        end

        it 'renders destroy' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
