# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :admin_login, mutation: Mutations::AdminLogin
    field :add_synonym, mutation: Mutations::AddSynonym
    field :review_word, mutation: Mutations::ReviewWord
    field :review_synonym, mutation: Mutations::ReviewSynonym
  end
end
