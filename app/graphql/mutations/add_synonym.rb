module Mutations
  class AddSynonym < BaseMutation
    argument :word, String, required: true
    argument :synonym, String, required: true

    field :result, String, null: false

    def resolve(word:, synonym:)
      word_instance = Word.find_or_create_by(str: word.downcase)
      create_synonym(word_instance, synonym)
    end

    private

    def create_synonym(word_instance, synonym_str)
      synonym_instance = word_instance.synonyms.create(synonym: synonym_str.downcase)

      if synonym_instance.persisted?
        { result: 'Synonym added successfully' }
      else
        { result: "Failed to add synonym: #{synonym_instance.errors.full_messages.join(', ')}" }
      end
    end
  end
end
