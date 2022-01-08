# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    title { 'MyString' }
    image do
      image_path = "#{Rails.root}/app/assets/images/default_badge.png"
      attach(io: File.open(image_path), filename: 'default_badge.png')
    end
  end
end
