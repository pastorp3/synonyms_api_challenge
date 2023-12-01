require 'rails_helper'

RSpec.describe Mutations::ReviewWord, type: :request do
  describe 'ReviewWord mutation' do
    let!(:admin_user) { create(:admin) }
    let!(:word) { create(:word) }

    
    context 'when user is an admin' do
      it 'authorizes a word' do
        mutation = <<~GQL
        mutation {
          reviewWord(input: { word: "#{word.str}", operation: AUTHORIZE }) {
            word {
              str
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

        expect(json_response['data']['reviewWord']['word']['str']).to eq(word.str)
        expect(json_response['data']['reviewWord']['word']['authorization']).to eq('authorized')
        expect(json_response['errors']).to be_nil
      end

      it 'deletes a word' do
        mutation = <<~GQL
          mutation {
            reviewWord(input: { word: "#{word.str}", operation: DELETE }) {
              word {
                str
              }
              errors
            }
          }
        GQL
        
        headers = { 'Authorization': "Bearer #{admin_user.generate_token}" }
        post '/graphql', params: { query: mutation }, headers: headers
  
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['reviewWord']['word']).to be_nil
        expect(json_response['data']['reviewWord']['errors']).to be_nil
      end
    end

    context 'when user is not an admin' do
      it 'returns authorization error' do
        mutation = <<~GQL
          mutation {
            reviewWord(input: { word: "#{word.str}", operation: AUTHORIZE }) {
              word {
                str
              }
              errors
            }
          }
        GQL

        post '/graphql', params: { query: mutation }

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)

        expect(json_response['data']['reviewWord']).to be_nil
        expect(json_response['errors'].first['message']).to eq("Access denied. Admin privileges required.")
      end
    end
  end
end
