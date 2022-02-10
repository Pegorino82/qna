# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FollowingPolicy, type: :policy do
  let(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question, author: author }
  let(:following) { create :following, question: question, author: author }

  subject { described_class }

  permissions :create? do
    it 'grant access if user presents' do
      expect(subject).to permit(user, create(:following))
    end

    permissions :destroy? do
      it 'grants access if user is present and author of following' do
        expect(subject).to permit(author, following)
      end

      it 'denies access if user is present and not author of following' do
        expect(subject).to_not permit(user, following)
      end
    end
  end
end
