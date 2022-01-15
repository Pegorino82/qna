# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    title { 'Test link' }
    url { 'http://test_link_url.com' }
  end
end
