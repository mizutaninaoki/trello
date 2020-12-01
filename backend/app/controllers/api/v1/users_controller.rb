# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_api_v1_user!, except: [:sample]

      def show
        render json: current_api_v1_user,
               message: 'user取得完了',
               status: :ok
      end

      # ログイン情報をnuxtに返すアクション
      # vueにてログイン後、this.$auth.userでユーザー情報を取得するtことができる
      def me
        # if api_v1_user_signed_in?
        #   render json: '未ログインのため、ユーザー情報を取得できませんでした。', message: '未ログイン', status: 200
        #   return
        # end

        render json: current_api_v1_user,
               message: 'ログインユーザー情報',
               status: :ok
      end


      def sample
        render json: '届いている',
        message: 'アクセスできてる',
        status: :ok
      end

      private

      def users_params
        params.require(:user).permit(:nickname, :password, :new_password, :new_password_confirmation)
      end
    end
  end
end
