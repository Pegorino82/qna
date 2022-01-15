FactoryBot.define do
  factory :answer do
    body { "Test Answer" }
    correct { false }
    question
    author { create :user }

    trait :invalid do
      body { nil }
    end
  end
end
