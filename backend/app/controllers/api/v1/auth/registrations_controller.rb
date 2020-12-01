# frozen_string_literal: true

module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        def create
          super
        end

        private

        def sign_up_params
          params.permit(:name, :nickname, :email, :password, :password_confirmation)
        end

        def account_update_params
          params.permit(:name, :nickname, :email, :password, :password_confirmation, :user_image)
        end
      end
    end
  end
end
