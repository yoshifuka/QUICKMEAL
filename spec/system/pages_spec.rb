require 'rails_helper'

RSpec.describe "Pages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "クイックミールの文字列が存在することを確認" do
        expect(page).to have_content 'クッキングレコード'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end
    end
  end
end
