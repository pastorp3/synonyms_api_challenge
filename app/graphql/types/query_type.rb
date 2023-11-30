module Types
  class QueryType < Types::BaseObject
    description "Queries for fetching objects."

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :word, Types::WordType, null: true, description: "Fetches a word by its string." do
      argument :str, String, required: true, description: "String of the word."
    end

    def word(str:)
      word = Word.find_by(str: str.downcase)

      return nil if word&.unauthorized? && !context[:current_admin]
      word
    end
  end
end
