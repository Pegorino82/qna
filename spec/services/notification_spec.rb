# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notification do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:following) { create :following, author: user, question: question }
  let(:answer) { create :answer, question: question }

  it 'sends notification to follower' do
    expect(FollowNotificationMailer).to receive(:send_notification).with(answer).and_call_original
    subject.send_notification(answer)
  end

  it 'does not send notification to not follower' do
    answer = create :answer

    expect(FollowNotificationMailer).to_not receive(:send_notification).with(answer).and_call_original
  end
end
