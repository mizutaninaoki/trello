# frozen_string_literal: true

class List < ApplicationRecord
  belongs_to :user
  # gem acts_as_listで親はuserと登録する
  acts_as_list scope: :user

  # gem acts_as_listでcardインスタンスに順番の概念を追加して、position: :asc順に必ず並べる様にする
  has_many :cards, -> { order(position: :asc) }, dependent: :destroy, inverse_of: :list

  # @param [Integer] from 移動前の位置
  # @param [Integer] to 移動後の位置
  def move_in_same_list(from, to)
    # child.insert_at(params[:to].to_i + 1）で対象のpositionを更新しています。
    cards[from].insert_at(to + 1)
  end

  # @param [Integer] from 移動前の位置
  # @param [Integer] to 移動後の位置
  # @param [Integer] to_list_id 移動後のリストID
  def move_to_different_list(from, to, to_list_id)
    ActiveRecord::Base.transaction do
      cards[from].list_id = to_list_id
      cards[from].save!
      cards[from].insert_at(to + 1)
    end
  end
end
