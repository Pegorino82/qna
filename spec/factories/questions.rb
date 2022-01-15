FactoryBot.define do
  factory :question do
    title { "Test Question Title" }
    body { "Test Question Body" }
    author { create :user }
    best_answer { nil }

    trait :invalid do
      title { nil }
    end
  end
end
