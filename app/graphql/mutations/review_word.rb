module Mutations
  class ReviewWord < BaseMutation
    argument :word, String, required: true
    argument :operation, Types::ReviewOperationEnum, required: true

    field :word, Types::WordType, null: true
    field :errors, [String], null: true

    def resolve(word:, operation:)
      require_admin_access

      word_instance = Word.find_by(str: word)

      return { errors: ['Word not found'] } if word_instance.nil?

      case operation
      when 'AUTHORIZE'
        authorize_word(word_instance)
      when 'DELETE'
        delete_word(word_instance)
      else
        { errors: ['Invalid operation'] }
      end
    end

    private

    def authorize_word(word_instance)
      if word_instance.authorize
        { word: word_instance, errors: nil }
      else
        { errors: ['Authorization failed'] }
      end
    end

    def delete_word(word_instance)
      if word_instance.synonyms.destroy_all && word_instance.destroy
        { word: nil, errors: nil }
      else
        { errors: word_instance.errors.full_messages }
      end
    end
  end
end
