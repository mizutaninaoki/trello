# frozen_string_literal: true

module Api
  module V1
    class ListsController < BaseController
      before_action :authenticate_api_v1_user!

      def index
        @lists = current_api_v1_user.lists.includes(cards: :tags).order(:position)

        render json: @lists,
               # includeオプションを付けないと孫テーブルより深い関連テーブルの値を取得できない
               include: { cards: :tags },
               message: 'done',
               status: :ok
      end

      def create
        @list = current_api_v1_user.lists.build(list_params)
        if @list.save
          render json: @list, status: :ok
        else
          render json: @list.errors.full_message, status: :not_found, message: 'リストの作成に失敗しました！'
        end
      end

      def destroy
        @list = current_api_v1_user.lists.find(params[:id])

        if @list.destroy
          # 削除に成功した時のステータスは204
          render json: { status: 204, list: @list }
        else
          render json: { status: 404, error: @list.errors.full_message }
        end
      end

      # rubocop:disable Metrics/AbcSize
      def move
        # もし違うlist間を移動していない時
        if params[:from_list_id] == params[:to_list_id]
          list = current_api_v1_user.lists.find(params[:to_list_id])
          # 同じリスト内でカードの位置変更
          list.move_in_same_list(params[:from].to_i, params[:to].to_i)
        else
          list = current_api_v1_user.lists.find(params[:from_list_id])
          # 違うリストへカードの位置変更
          list.move_to_different_list(params[:from].to_i, params[:to].to_i, params[:to_list_id].to_i)
        end

        head :ok
      end
      # rubocop:enable Metrics/AbcSize

      def list_move
        # @parent.children[params[:from].to_i]で対象のモデルを取得しています。
        # (has_manyのアソシエーションでposition: :asc順に並べる様に設定している)
        from_list = current_api_v1_user.lists[params[:from_position].to_i]
        # child.insert_at(params[:to].to_i + 1）で対象のpositionを更新しています。
        from_list.insert_at(params[:to_position].to_i + 1)
        head :ok
      end

      private

      def list_params
        params.permit(:title)
      end
    end
  end
end
