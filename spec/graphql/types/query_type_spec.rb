require 'rails_helper'

RSpec.describe Types::QueryType, type: :request do
  describe 'word query' do
    let!(:word) { create(:word, str: 'example') }
    let!(:synonym1) { create(:synonym, word_id: word.id, synonym: 'similar1') }

    it 'fetches an authorized word by its string and synonym' do
      word.authorize
      synonym1.authorize
      query = <<~GQL
        query {
          word(str: "example") {
            str
            synonyms {
              synonym
            }
          }
        }
      GQL

      post '/graphql', params: { query: query }
      
      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)

      expect(json_response['data']['word']['str']).to eq(word.str)
      expect(json_response['data']['word']['synonyms'].first['synonym']).to eq(synonym1.synonym)
    end

    it 'returns nil for an unauthorized word without admin context' do
      # Assuming you have a method like unauthorized? in your Word model

      query = <<~GQL
        query {
          word(str: "example") {
            str
          }
        }
      GQL

      post '/graphql', params: { query: query }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)

      expect(json_response['data']['word']).to be_nil
    end

    it 'fetches an unauthorized word with admin context' do
      admin_user = create(:admin)

      query = <<~GQL
        query {
          word(str: "example") {
            str
            synonyms {
              synonym
            }
          }
        }
      GQL

      headers = { 'Authorization': "Bearer #{admin_user.generate_token}" }
      post '/graphql', params: { query: query }, headers: headers

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)

      expect(json_response['data']['word']['str']).to eq(word.str)
      expect(json_response['data']['word']['synonyms'].first['synonym']).to eq(synonym1.synonym)
    end
  end
end
