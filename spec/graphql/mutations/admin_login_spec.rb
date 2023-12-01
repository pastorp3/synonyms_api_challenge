# spec/graphql/mutations/admin_login_spec.rb

require 'rails_helper'

RSpec.describe Mutations::AdminLogin, type: :request do
  describe 'AdminLogin mutation' do
    let!(:admin) { create(:admin, username: 'admin_user', password: 'admin_password') }

    it 'logs in an admin with valid credentials' do
      mutation = <<~GQL
        mutation {
          adminLogin(input: { user: "admin_user", password: "admin_password" }) {
            token
            errors
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)

      expect(json_response['data']['adminLogin']['token']).not_to be_nil
      expect(json_response['data']['adminLogin']['errors']).to be_empty
    end

    it 'handles invalid credentials' do
      mutation = <<~GQL
        mutation {
          adminLogin(input: { user: "invalid_user", password: "invalid_password" }) {
            token
            errors
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)

      expect(json_response['data']['adminLogin']['token']).to be_nil
      expect(json_response['data']['adminLogin']['errors']).to contain_exactly('Invalid username or password')
    end
  end
end
