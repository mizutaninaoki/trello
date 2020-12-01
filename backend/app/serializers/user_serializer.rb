# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :nickname,
             :user_image

  has_many :lists

  # もし画像をS3へアップロードしていれば、画像のurlも返す
  def user_image
    # ※objectはSerializernewなどで渡されたオブジェクト(レコード)自身
    { id: object.user_image.id, image_url: object.user_image.service_url, filename: object.user_image.blob.filename } if object.user_image.attached?
  end
end
