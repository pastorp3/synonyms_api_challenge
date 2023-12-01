# spec/graphql/mutations/add_synonym_spec.rb

require 'rails_helper'

RSpec.describe Mutations::AddSynonym, type: :request do
  describe 'AddSynonym mutation' do
    let!(:word) { create(:word, str: 'example') }

    it 'adds a synonym to an existing word' do
      mutation = <<~GQL
        mutation {
          addSynonym(input: { word: "example", synonym: "similar" }) {
            result
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)

      expect(json_response['data']['addSynonym']['result']).to eq('Synonym added successfully')

      word.reload
      expect(word.synonyms.count).to eq(1)
      expect(word.synonyms.first.synonym).to eq('similar')
    end

    it 'creates a new word and adds a synonym' do
      mutation = <<~GQL
        mutation {
          addSynonym(input: { word: "new_word", synonym: "fresh" }) {
            result
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['addSynonym']['result']).to eq('Synonym added successfully')

      new_word = Word.find_by(str: 'new_word')
      expect(new_word).not_to be_nil
      expect(new_word.synonyms.count).to eq(1)
      expect(new_word.synonyms.first.synonym).to eq('fresh')
    end
  end
end
