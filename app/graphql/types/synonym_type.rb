# frozen_string_literal: true

module Types
  class SynonymType < Types::BaseObject
    field :id, ID, null: false
    field :word_id, Integer, null: false
    field :synonym, String
    field :authorization, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def authorization
      object.authorization_status if context[:current_admin]
    end
  end
end
