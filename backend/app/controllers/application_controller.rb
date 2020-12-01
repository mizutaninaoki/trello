# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :skip_session

  # devise_token_authを使用時必要
  # これをしないとActionDispatch::Cookies::CookieOverflow (ActionDispatch::Cookies::CookieOverflow):が発生する
  #   参照: https://github.com/lynndylanhurley/devise_token_auth/issues/718
  def skip_session
    request.session_options[:skip] = true
  end
end
