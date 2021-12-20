FactoryBot.define do
  factory :answer do
    body { "MyString" }
    correct { false }
    question { nil }
  end
end
