# frozen_string_literal: true

module Api
  module V1
    class CardsController < BaseController
      before_action :authenticate_api_v1_user!

      def create
        # ルーティングで囲んである時は、"親モデル_id"の形でcreateとか渡ってくる
        @list = current_api_v1_user.lists.find(params[:list_id])
        @card = @list.cards.build(card_params)
        # stringParameterはqs.stringify(params)で:tag_listにハッシュで渡ってきてしまうため、
        # acts-as-taggable-onで保存できる形に配列に直して、acts-as-taggable-onのaddメソッドで追加してあげる
        # @card.tag_list.add(params[:card][:tag_list])

        if @card.save
          render json: @card, status: :created
        else
          render json: { status: 404, error: @card.errors.full_message }
        end
      end

      def update
        @card = current_api_v1_user.lists.find(params[:list_id]).cards.find(params[:id])
        @card.assign_attributes(card_params)

        if @card.save
          render json: @card, status: :ok
        else
          render json: { status: 404, error: @card.errors.full_message }
        end
      end

      def destroy
        @card = current_api_v1_user.lists.find(params[:list_id]).cards.find(params[:id])

        if @card.destroy
          # 削除に成功した時のステータスは204
          render json: { status: 204, card: @card }
        else
          render json: { status: 404, error: @card.errors.full_message }
        end
      end

      private

      def card_params
        params.require(:card).permit(:title, :content, :tag_list, images: [])
      end
    end
  end
end
