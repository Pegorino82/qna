require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT': 'application/json' } }

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create :user }
    let(:access_token) { create :access_token }
    let!(:question) { create :question, author: user }
    let!(:files) { [
      fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain'),
      fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain')] }
    let!(:resource) { create :answer, question: question, files: files, author: user }
    let!(:comments) { create_list(:comment, 3, commentable: resource, author: user) }
    let!(:links) { create_list(:link, 3, linkable: resource) }
    let(:resource_response) { json['answer'] }
    let(:api_path) { "/api/v1/answers/#{resource.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status if access token is valid' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body question_id created_at updated_at].each do |attr|
          expect(resource_response[attr]).to eq resource.send(attr).as_json
        end
      end

      it_behaves_like 'API nestable' do
        let(:skipped_params) { %w[] }
        let(:comments_public_fields) { %w[id body author_id created_at updated_at] }
        let(:links_public_fields) { %w[id title url created_at updated_at] }
      end
    end
  end
end
