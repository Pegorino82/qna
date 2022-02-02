# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    uid { 123 }
    provider { 'vkontakte' }
    user { nil }
  end
end
