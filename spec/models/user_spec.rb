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
end
