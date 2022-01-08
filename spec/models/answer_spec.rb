# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:award) }
  it { should belong_to(:author).class_name('User') }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of(:body) }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
