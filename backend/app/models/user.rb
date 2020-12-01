# frozen_string_literal: true

class User < ApplicationRecord
  # gem Deviseを入れていないため、下記１行を加える必要あり
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_one_attached :user_image

  # gem acts_as_listでcardインスタンスに順番の概念を追加して、position: :asc順に必ず並べる様にする
  has_many :lists, -> { order(position: :asc) }, inverse_of: :user
end
