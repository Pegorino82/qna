# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question').dependent(:destroy) }
  it { should have_many(:answers).class_name('Answer').dependent(:destroy) }
  it { should have_many(:votes).class_name('Vote') }
  it { should have_many(:comments).class_name('Comment') }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:followings).class_name('Following').dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

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

  describe '.find_for_auth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
