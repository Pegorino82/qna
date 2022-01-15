FactoryBot.define do
  factory :vote do
    value { 0 }
    author { create :user }
    votable { nil }
  end
end
