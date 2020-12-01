# frozen_string_literal: true

class TagSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :taggings_count

  belongs_to :card
end
