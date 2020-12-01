# frozen_string_literal: true

class CreateCards < ActiveRecord::Migration[6.0]
  def change
    create_table :cards do |t|
      t.references :list, null: false, foreign_key: true
      t.text :content
      t.string :title
      t.integer :position

      t.timestamps
    end
  end
end
