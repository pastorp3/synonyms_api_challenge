class CreateSynonyms < ActiveRecord::Migration[7.0]
  def change
    create_table :synonyms do |t|
      t.references :word, null: false, foreign_key: true
      t.string :synonym
      t.integer :authorization_status, default: 0

      t.timestamps
    end
  end
end
