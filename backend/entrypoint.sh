#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# 本番環境の場合
if [ $RAILS_ENV = "production" ]; then
  rails db:prepare # DBがなかったらDBを作成してseed、migrate、DBがあったらmigrateだけするメソッド

  # Fargateで立ち上げたコンテナにはSSHで入れない為、セッションマネージャーから入れるように以下のコマンドをコンテナ起動時に実行
  # railsが入っているコンテナをSSMエージェントに登録
  # amazon-ssm-agent -register -code "${SSM_ACTIVATION_CODE}" -id "${SSM_ACTIVATION_ID}" -region "ap-northeast-1"

  # SSMエージェントをバックグラウンドで起動
  # amazon-ssm-agent &
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
