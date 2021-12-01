require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }

  describe "新規登録ページ" do
    before do
      visit new_user_registration_path
    end

    context "ページレイアウト" do
      it "「新規登録」の文字列が存在することを確認" do
        expect(page).to have_content '新規登録'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('新規登録')
      end
    end

    context "新規登録処理" do
      it "有効なユーザーで新規登録を行うと新規登録成功のフラッシュが表示されること" do
        fill_in "ユーザー名", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        click_button "登録する"
        expect(page).to have_content "アカウント登録が完了しました。"
      end
    end
  end


  describe "ログインページ" do
    before do
      visit new_user_session_path
    end

    context "ページレイアウト" do
      it "「ログイン」の文字列が存在することを確認" do
        expect(page).to have_content 'ログイン'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('ログイン')
      end

      it "ヘッダーにログインページへのリンクがあることを確認" do
        expect(page).to have_link 'ログイン', href: new_user_session_path
      end

      it "ログインフォームのラベルが正しく表示される" do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
      end

      it "ログインボタンが表示される" do
        expect(page).to have_button 'ログイン'
      end
    end
  end

  describe "プロフィールページ" do
    context "ページレイアウト" do
      before do
        sign_in user
        create_list(:dish, 10, user: user)
        visit user_path(user)
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "ユーザー情報が表示されることを確認" do
        expect(page).to have_content user.username
        expect(page).to have_content user.introduction
      end

      it "料理の件数が表示されていることを確認" do
        expect(page).to have_content "料理 (#{user.dishes.count}品)"
      end

      it "料理の情報が表示されていることを確認" do
        Dish.take(5).each do |dish|
          expect(page).to have_link dish.name
          expect(page).to have_content dish.description
          expect(page).to have_content dish.user.username
          expect(page).to have_content dish.required_time
        end
      end
    end
  end

  describe "プロフィール編集ページ" do
    before do
      sign_in user
      visit user_path(user)
      click_link "プロフィール編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title('プロフィール編集')
      end
    end

    it "有効なプロフィール更新を行うと、更新成功のフラッシュが表示されること" do
      fill_in "user[username]", with: "Edit Example User"
      fill_in "メールアドレス", with: "edit-user@example.com"
      fill_in "自己紹介", with: "編集：初めまして"
      click_button "更新する"
      expect(page).to have_content "アカウント情報を変更しました。"
      expect(user.reload.username).to eq "Edit Example User"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduction).to eq "編集：初めまして"
    end

    it "無効なプロフィール更新をしようとすると、適切なエラーメッセージが表示されること" do
      fill_in "user[username]", with: ""
      fill_in "メールアドレス", with: ""
      click_button "更新する"
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(user.reload.email).not_to eq ""
    end
  end
end
