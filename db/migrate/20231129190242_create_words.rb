class CreateWords < ActiveRecord::Migration[7.0]
  def change
    create_table :words do |t|
      t.string :str
      t.integer :authorization_status, default: 0

      t.timestamps
    end
  end
end
