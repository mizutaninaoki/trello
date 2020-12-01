# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'visitors#index'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        # 必ず'api/v1/...'と書かなければいけない
        registrations: 'api/v1/auth/registrations'
      }

      # プロフィール等
      resource :users do
        # ログインユーザーの情報を返すルーティング
        collection do
          get :me
          get :sample
        end
      end

      # リスト
      resources :lists, only: %i[index create destroy], shallow: true do
        # カード
        resources :cards, only: %i[index create update destroy]

        member do
          # ソートする
          patch :move
          patch :list_move
        end
      end
    end
  end
end
