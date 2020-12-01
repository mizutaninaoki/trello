# frozen_string_literal: true

class ListSerializer < ActiveModel::Serializer
  attributes :id,
             :user_id,
             :title

  has_many :cards
end
