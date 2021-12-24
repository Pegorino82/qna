# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).class_name('Question') }
  it { should have_many(:answers).class_name('Answer') }
end
