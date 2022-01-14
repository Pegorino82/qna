# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class }
  let(:votable_author) { create :user }
  let(:vote_author) { create :user }
  let(:votable) { create(described_class.to_s.underscore.to_sym, author: votable_author) }
  let(:vote) { create :vote, votable: votable, author: vote_author }

  context "likes #{described_class.to_s}" do
    it '#vote_count' do
      vote.like
      expect(votable.vote_count).to eq(1)
    end
  end

  context "dislikes #{described_class.to_s}" do
    it '#vote_count' do
      vote.dislike
      expect(votable.vote_count).to eq(-1)
    end
  end
end

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should belong_to(:author).class_name('User') }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
