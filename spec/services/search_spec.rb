require 'rails_helper'

RSpec.describe Services::Search do
  let(:service) { double('Services::Search') }

  it 'calls for question' do
    params = { text: 'text', classes: [Question], page: 1 }
    allow(service).to receive(:new).with(params)
    allow(ThinkingSphinx).to receive(:search).with('text', classes: [Question], page: 1)
  end

  it 'calls for answer' do
    params = { text: 'text', classes: [Answer], page: 1 }
    allow(service).to receive(:new).with(params)
    allow(ThinkingSphinx).to receive(:search).with('text', classes: [Answer], page: 1)
  end

  it 'calls for comment' do
    params = { text: 'text', classes: [Comment], page: 1 }
    allow(service).to receive(:new).with(params)
    allow(ThinkingSphinx).to receive(:search).with('text', classes: [Comment], page: 1)
  end

  it 'calls for user' do
    params = { text: 'text', classes: [User], page: 1 }
    allow(service).to receive(:new).with(params)
    allow(ThinkingSphinx).to receive(:search).with('text', classes: [User], page: 1)
  end

  it 'calls for all' do
    params = { text: 'text', classes: [Question, Answer, Comment, User], page: 1 }
    allow(service).to receive(:new).with(params)
    allow(ThinkingSphinx).to receive(:search).with('text', classes: [Question, Answer, Comment, User], page: 1)
  end
end
