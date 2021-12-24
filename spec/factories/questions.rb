FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author { nil }

    trait :invalid do
      title { nil }
    end
  end
end
