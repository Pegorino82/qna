# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :title }
  it { should validate_presence_of :url }

  it { should_not allow_value('bad link').for(:url) }
end
