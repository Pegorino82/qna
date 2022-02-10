# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('Services::Notification') }
  let(:answer) { create :answer }

  before do
    allow(Services::Notification).to receive(:new).and_return(service)
  end

  it 'calls Services::Notification#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    NotificationJob.perform_now(answer)
  end
end
