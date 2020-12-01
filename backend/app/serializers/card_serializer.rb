# frozen_string_literal: true

class CardSerializer < ActiveModel::Serializer
  attributes :id,
             :list_id,
             :title,
             :content,
             :images,
             :created_at

  belongs_to :list
  has_many :tags

  # もし画像をS3へアップロードしていれば、画像のurlも配列で返す
  def images
    # ※objectはSerializernewなどで渡されたオブジェクト(レコード)自身
    if object.images.attached?
      object.images.map do |image|
        { id: image.id, image_url: image.service_url, filename: image.blob.filename }
      end
    else
      # 画像が１つもなければ、配列を返す
      []
    end
  end
end
