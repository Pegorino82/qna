# frozen_string_literal: true

shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      do_request(method, api_path, params: { access_token: '123' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
