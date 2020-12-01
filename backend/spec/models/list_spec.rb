# frozen_string_literal: true

require 'rails_helper'

RSpec.describe List, type: :model do
  describe '#サンプルテスト' do
    context 'サンプルの場合' do
      it 'メッセージが送信できないこと' do
        expect(2 + 2).to eq 4
      end
    end
  end
end
