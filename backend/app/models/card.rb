# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :list

  # ActiveStorage
  has_many_attached :images

  acts_as_taggable # タグ機能を入れるために追加
  # acts_as_taggable_on :tags　と同じ意味のエイリアス
  # tags のなかにIDやら名前などが入る。イメージ的には親情報。

  # gem acts_as_listで親はlistと登録する
  acts_as_list scope: :list
end
