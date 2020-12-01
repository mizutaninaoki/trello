# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '#サンプルテスト' do
    context 'サンプルの場合' do
      it 'メッセージが送信できないこと' do
        expect(1 + 1).to eq 2
      end
    end
  end
end
