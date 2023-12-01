require 'rails_helper'

RSpec.describe Mutations::ReviewSynonym, type: :request do
  describe 'ReviewSynonym mutation' do
    let!(:admin_user) { create(:admin) }
    let!(:synonym) { create(:synonym) }

    context 'when user is an admin' do
      it 'authorizes a synonym' do
        mutation = <<~GQL
          mutation {
            reviewSynonym(input: { synonym: "#{synonym.synonym}", operation: AUTHORIZE }) {
              synonym {
                synonym
                authorization
              }
              errors
            }
          }
        GQL

        headers = { 'Authorization': "Bearer #{admin_user.generate_token}" }
        post '/graphql', params: { query: mutation }, headers: headers

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['reviewSynonym']['synonym']['synonym']).to eq(synonym.synonym)
        expect(json_response['data']['reviewSynonym']['synonym']['authorization']).to eq('authorized')
        expect(json_response['errors']).to be_nil
      end

      it 'deletes a synonym' do
        mutation = <<~GQL
          mutation {
            reviewSynonym(input: { synonym: "#{synonym.synonym}", operation: DELETE }) {
              synonym {
                synonym
              }
              errors
            }
          }
        GQL

        headers = { 'Authorization': "Bearer #{admin_user.generate_token}" }
        post '/graphql', params: { query: mutation }, headers: headers

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['reviewSynonym']['synonym']).to be_nil
        expect(json_response['data']['reviewSynonym']['errors']).to be_nil
      end
    end

    context 'when user is not an admin' do
      it 'returns authorization error' do
        mutation = <<~GQL
          mutation {
            reviewSynonym(input: { synonym: "#{synonym.synonym}", operation: AUTHORIZE }) {
              synonym {
                synonym
              }
              errors
            }
          }
        GQL

        post '/graphql', params: { query: mutation }

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['reviewSynonym']).to be_nil
        expect(json_response['errors'].first['message']).to eq("Access denied. Admin privileges required.")
      end
    end
  end
end
