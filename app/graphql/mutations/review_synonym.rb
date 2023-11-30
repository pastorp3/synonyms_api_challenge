module Mutations
  class ReviewSynonym < BaseMutation
    argument :synonym, String, required: true
    argument :operation, Types::ReviewOperationEnum, required: true

    field :synonym, Types::SynonymType, null: true
    field :errors, [String], null: true

    def resolve(synonym:, operation:)
      require_admin_access
      
      synonym_instance = Synonym.find_by(synonym: synonym)
      
      return { errors: ['Word not found'] } if synonym_instance.nil?

      case operation
      when 'AUTHORIZE'
        authorize_synonym(synonym_instance)
      when 'DELETE'
        delete_synonym(synonym_instance)
      else
        { errors: ['Invalid operation'] }
      end
    end

    private

    def authorize_synonym(synonym_instance)
      if synonym_instance.authorize
        { synonym: synonym_instance, errors: nil }
      else
        { errors: ['Authorization failed'] }
      end
    end

    def delete_synonym(synonym_instance)
      if synonym_instance.destroy
        { synonym: nil, errors: nil }
      else
        { errors: synonym_instance.errors.full_messages }
      end
    end
  end
end
