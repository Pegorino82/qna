# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question') }
  it { should have_many(:answers).class_name('Answer') }

  let(:user) { create :user }

  context 'User author' do
    let(:question) { create :question, author: user }
    it 'of question' do
      expect user.author_of?(question) == true
    end
    it 'of answer' do
      answer = create :answer, question: question, author: user
      expect user.author_of?(answer) == true
    end
  end

  context 'User do not author' do
    let(:another_user) { create :user }
    let(:question) { create :question, author: another_user }
    it 'of question' do
      expect user.author_of?(question) == false
    end
    it 'of answer' do
      answer = create :answer, question: question, author: another_user
      expect user.author_of?(answer) == false
    end
  end
end
