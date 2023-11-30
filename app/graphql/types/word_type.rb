# frozen_string_literal: true

module Types
  class WordType < Types::BaseObject
    field :id, ID, null: false
    field :str, String
    field :authorization, String
    field :synonyms, [Types::SynonymType], null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def synonyms
      if context[:current_admin]
        object&.synonyms
      else
        object&.synonyms&.authorized
      end
    end

    def authorization
      object.authorization_status if context[:current_admin]
    end
  end
end
