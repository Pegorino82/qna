# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'Test Comment' }
    commentable { nil }
    author { create :user }

    trait :invalid do
      body { nil }
    end
  end
end
