FactoryBot.define do
  factory :answer do
    body { "Test Answer" }
    correct { false }
    question { nil }
    author { nil }

    trait :invalid do
      body { nil }
    end
  end
end
