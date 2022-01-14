# frozen_string_literal: true

require 'rails_helper'

shared_examples 'voted' do
  let(:user) { create :user }
  let(:votable_author) { create :user }
  let(:votable) { create(described_class.controller_name.singularize.underscore.to_sym, author: votable_author) }

  describe 'POST #like', js: true do
    context 'Authenticated user' do
      before { login(user) }

      context 'vote once' do
        before { post :like, params: { id: votable }, format: :json}

        it "increments #{described_class.controller_name.to_s}'s vote" do
          expect(votable.vote_count).to eq 1
        end

        it 'responds json' do
          res = {
            vote_value: 1,
            votable_id: votable.id,
            votable_class: votable.class.name.underscore,
            vote_count: 1
          }.as_json
          expect(JSON.parse(response.body)).to eq res
        end
      end

      context "can't votes twice" do
        before do
          post :like, params: { id: votable }, format: :json
          post :like, params: { id: votable }, format: :json
        end

        it "can't increments #{described_class.controller_name.to_s}'s vote twice" do
          expect(votable.vote_count).to eq 1
        end

        it 'responds json' do
          res = {
            vote_value: 1,
            votable_id: votable.id,
            votable_class: votable.class.name.underscore,
            vote_count: 1
          }.as_json
          expect(JSON.parse(response.body)).to eq res
        end
      end

      context 'cancel' do
        before do
          post :like, params: { id: votable }, format: :json
          post :dislike, params: { id: votable }, format: :json
        end

        it "can cancel #{described_class.controller_name.to_s}'s like" do
          expect(votable.vote_count).to eq 0
        end

        it 'responds json' do
          res = {
            vote_value: 0,
            votable_id: votable.id,
            votable_class: votable.class.name.underscore,
            vote_count: 0
          }.as_json
          expect(JSON.parse(response.body)).to eq res
        end
      end
    end

    context "vote his #{described_class.controller_name.to_s}" do
      before { login(votable_author) }

      it "can't increments #{described_class.controller_name.to_s}'s vote" do
        post :like, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 422
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name.to_s}" do
        post :like, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end
  end

  describe 'POST #dislike' do
    context 'Authenticated user' do
      before { login(user) }

      context 'votes once' do
        before {  post :dislike, params: { id: votable }, format: :json }

        it "decrements #{described_class.controller_name.to_s}'s vote" do
          expect(votable.vote_count).to eq -1
        end

        it 'responds json' do
          res = {
            vote_value: -1,
            votable_id: votable.id,
            votable_class: votable.class.name.underscore,
            vote_count: -1
          }.as_json
          expect(JSON.parse(response.body)).to eq res
        end
      end

      context "can't votes twice" do
        before do
          post :dislike, params: { id: votable }, format: :json
          post :dislike, params: { id: votable }, format: :json
        end

        it "can't decrements #{described_class.controller_name.to_s}'s vote twice" do
          expect(votable.vote_count).to eq -1
        end

        it 'responds json' do
          res = {
            vote_value: -1,
            votable_id: votable.id,
            votable_class: votable.class.name.underscore,
            vote_count: -1
          }.as_json
          expect(JSON.parse(response.body)).to eq res
        end
      end

      context 'cancel' do
        before do
          post :dislike, params: { id: votable }, format: :json
          post :like, params: { id: votable }, format: :json
        end

        it "can cancel #{described_class.controller_name.to_s}'s like" do
          expect(votable.vote_count).to eq 0
        end

        it 'responds json' do
          res = {
            vote_value: 0,
            votable_id: votable.id,
            votable_class: votable.class.name.underscore,
            vote_count: 0
          }.as_json
          expect(JSON.parse(response.body)).to eq res
        end
      end
    end

    context "vote his #{described_class.controller_name.to_s}" do
      before { login(votable_author) }

      it "can't decrements #{described_class.controller_name.to_s}'s vote" do
        post :dislike, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 422
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name.to_s}" do
        post :dislike, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end
  end
end

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'GET #index' do
    let(:questions) { create_list :question, 3, author: user }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update', js: true do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end
      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change the question' do
        question.reload

        expect(question.title).to eq 'Test Question Title'
        expect(question.body).to eq 'Test Question Body'
      end
      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end

    context 'user is not author' do
      let(:other_user) { create :user }
      let!(:other_question) { create :question, author: other_user }

      it "doesn't change other's question" do
        patch :update, params: { id: other_question, question: { title: 'Edited Title', body: 'Edited Body' } },
                       format: :js
        other_question.reload

        expect(other_question.title).to eq 'Test Question Title'
        expect(other_question.body).to eq 'Test Question Body'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'user is author' do
      let!(:question) { create :question, author: user }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not author' do
      let(:other_user) { create :user }
      let!(:other_question) { create :question, author: other_user }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
      end

      it 'does not delete file' do
        file = fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain')
        other_question.files.attach(file)

        expect { delete :destroy, params: { id: other_question, file_id: other_question.files.first } }
          .to_not change(question.files, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: other_question }
        expect(response).to redirect_to other_question
      end
    end
  end
end
