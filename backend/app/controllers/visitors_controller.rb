# frozen_string_literal: true

class VisitorsController < BaseController
  def index
    render json: { message: 'トップページです！' }
  end
end
