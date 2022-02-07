FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'test app' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '12345678' }
    secret { 'qwertyu' }
  end
end
