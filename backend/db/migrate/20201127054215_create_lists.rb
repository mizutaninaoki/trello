# frozen_string_literal: true

class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.integer :position

      t.timestamps
    end
  end
end
