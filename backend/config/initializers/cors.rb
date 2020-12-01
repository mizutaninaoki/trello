# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # originsのところにアクセスを許可したいドメインを入力する形となります。
    # origins 'localhost:3000'
    origins '*'
    resource '*',
             headers: :any,
             # exposeで指定したものは、レスポンスのHTTPヘッダとして公開を許可する（別オリジンからのリクエスト者でも見えるようにする）
             expose: %w[access-token expiry token-type uid client],
             methods: %i[get post options delete put patch]
  end
end
