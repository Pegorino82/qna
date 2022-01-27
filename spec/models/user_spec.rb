# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question') }
  it { should have_many(:answers).class_name('Answer') }
  it { should have_many(:votes).class_name('Vote') }
  it { should have_many(:comments).class_name('Comment') }
  it { should have_many(:awards) }

  let(:user) { create :user }

  context 'User author' do
    let(:question) { create :question, author: user }
    it 'of question' do
      expect(user).to be_author_of(question)
    end
    it 'of answer' do
      answer = create :answer, question: question, author: user
      expect(user).to be_author_of(answer)
    end
  end

  context 'User do not author' do
    let(:another_user) { create :user }
    let(:question) { create :question, author: another_user }
    it 'of question' do
      expect(user).to_not be_author_of(question)
    end
    it 'of answer' do
      answer = create :answer, question: question, author: another_user
      expect(user).to_not be_author_of(answer)
    end
  end

  describe  '.find_for_auth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }

    context 'already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', email: user.email) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', email: 'new@mail.com') }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)

          expect(user.email).to eq auth.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)

          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
