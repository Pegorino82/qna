# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { create :user }
  let(:admin) { create :user, role: :admin }

  subject { described_class }

  permissions :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, create(:answer))
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is admin' do
      expect(subject).to permit(admin, create(:answer))
    end

    it 'grants access if user is author' do
      expect(subject).to permit(user, create(:answer, author: user))
    end

    it 'denies access if user is not author' do
      expect(subject).not_to permit(User.new, create(:answer, author: user))
    end
  end

  permissions :best_answer? do
    let(:other_user) { create :user }

    let(:question) { create :question, author: user }
    let(:answer) { create :answer, question: question, author: user }
    let(:question_other_answer) { create :answer, question: question, author: other_user }

    it 'grants access if user is admin' do
      expect(subject).to permit(admin, answer)
    end

    it "grants access if user is question's author" do
      expect(subject).to permit(user, question_other_answer)
    end

    it "denies access if user is not question's author" do
      expect(subject).to_not permit(other_user, answer)
    end
  end
end
