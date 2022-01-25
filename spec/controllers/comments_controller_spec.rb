# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:commented_author) { create :user }
  let(:commentable) { create(:question, author: commented_author) }

  describe 'POST #create', js: true do
    context 'Authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it "saves a new comment to database" do
          expect do
            puts attributes_for(:comment, commentable: commentable, author: user)
            post :create,
                 params: {
                   comment: {
                     body: 'New comment',
                     commentable_type: commentable.class.name,
                     commentable_id: commentable.id,
                     author_id: user.id
                   }
                 },
                 format: :json
          end.to change(commentable.comments, :count).by(1)
        end
      end
    end

    context 'Unauthenticated user' do
      it "can't comment question" do
      end
    end
  end
end
