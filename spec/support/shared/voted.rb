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
        before { post :like, params: { id: votable }, format: :json }

        it "increments #{described_class.controller_name}'s vote" do
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

        it "can't increments #{described_class.controller_name}'s vote twice" do
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

        it "can cancel #{described_class.controller_name}'s like" do
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

    context "vote his #{described_class.controller_name}" do
      before { login(votable_author) }

      it "can't increments #{described_class.controller_name}'s vote" do
        post :like, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 401
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name}" do
        post :like, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end
  end

  describe 'POST #dislike' do
    context 'Authenticated user' do
      before { login(user) }

      context 'votes once' do
        before { post :dislike, params: { id: votable }, format: :json }

        it "decrements #{described_class.controller_name}'s vote" do
          expect(votable.vote_count).to eq(-1)
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

        it "can't decrements #{described_class.controller_name}'s vote twice" do
          expect(votable.vote_count).to eq(-1)
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

        it "can cancel #{described_class.controller_name}'s like" do
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

    context "vote his #{described_class.controller_name}" do
      before { login(votable_author) }

      it "can't decrements #{described_class.controller_name}'s vote" do
        post :dislike, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
        expect(response.status).to eq 401
      end
    end

    context 'Unauthenticated user' do
      it "can't vote #{described_class.controller_name}" do
        post :dislike, params: { id: votable }, format: :json
        expect(votable.vote_count).to eq 0
      end
    end
  end
end
