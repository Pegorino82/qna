# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('Services::DailyDigest') }

  before do
    allow(Services::DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls Services::DailyDigest#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
