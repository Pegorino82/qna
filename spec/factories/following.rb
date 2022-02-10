# frozen_string_literal: true

FactoryBot.define do
  factory :following do
    question { create :question }
    author { create :user }
  end
end
