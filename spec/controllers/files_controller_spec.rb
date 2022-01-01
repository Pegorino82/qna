# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:user) { create :user }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'user is author' do
        let!(:question) { create :question, author: user, files: [file] }

        it "deletes question's file" do
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

        it "does not delete question's file" do
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

    context 'Unauthenticated user' do
      let!(:question) { create :question, author: user, files: [file] }

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
