require 'rails_helper'

RSpec.describe "Dishes", type: :system do
  let!(:user) { create(:user) }
  let!(:dish) { create(:dish, user: user) }

  describe "料理投稿ページ" do
    before do
      sign_in user
      visit new_dish_path
    end

    context "ページレイアウト" do
      it "「料理投稿」の文字列が存在すること" do
        expect(page).to have_content '料理投稿'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('料理投稿')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content '料理名'
        expect(page).to have_content '説明'
        expect(page).to have_content '分量 [人分]'
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '作り方'
        expect(page).to have_content '所要時間 [分]'
        expect(page).to have_content '材料 [10種類まで登録可]'
        expect(page).to have_content '量'
      end

      it "材料入力部分が10行表示されること" do
        expect(page).to have_css 'input.ingredient_name', count: 10
        expect(page).to have_css 'input.ingredient_quantity', count: 10
      end
    end

    context "料理投稿処理" do
      it "有効な情報で料理投稿を行うと料理投稿成功のフラッシュが表示されること" do
        fill_in "料理名", with: "イカの塩焼き"
        fill_in "説明", with: "冬に食べたくなる、身体が温まる料理です"
        fill_in "分量", with: 1
        fill_in "コツ・ポイント", with: "ピリッと辛めに味付けするのがオススメ"
        fill_in "作り方", with: "切って煮る"
        fill_in "所要時間", with: 15
        attach_file "dish[picture]", "#{Rails.root}/spec/fixtures/test_dish1.jpg"
        fill_in "dish[ingredients_attributes][0][name]", with: "豆腐"
        fill_in "dish[ingredients_attributes][0][quantity]", with: "2個"
        click_button "登録する"
        expect(page).to have_content "料理が登録されました！"
      end

      it "無効な情報で料理投稿を行うと料理投稿失敗のフラッシュが表示されること" do
        fill_in "料理名", with: ""
        fill_in "説明", with: "冬に食べたくなる、身体が温まる料理です"
        fill_in "分量", with: 1
        fill_in "コツ・ポイント", with: "ピリッと辛めに味付けするのがオススメ"
        fill_in "作り方", with: "切って煮る"
        fill_in "所要時間", with: 15
        click_button "登録する"
        expect(page).to have_content "料理名を入力してください"
      end
    end
  end

  describe "料理詳細ページ" do
    context "ページレイアウト" do
      before do
        sign_in user
        visit dish_path(dish)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{dish.name}")
      end

      it "料理情報が表示されること" do
        expect(page).to have_content dish.name
        expect(page).to have_content dish.description
        expect(page).to have_content dish.portion
        expect(page).to have_content dish.tips
        expect(page).to have_content dish.way_of_cooking
        expect(page).to have_content dish.required_time
        expect(page).to have_link nil, href: dish_path(dish), class: 'dish-picture-show'
      end
    end

    context "コメントの登録＆削除" do
      it "自分の料理に対するコメントの登録＆削除が正常に完了すること" do
        sign_in user
        visit dish_path(dish)
        fill_in "comment_content", with: "美味しい"
        click_button "コメント"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_selector 'span', text: user.username
          expect(page).to have_selector 'span', text: '美味しい'
        end
        expect(page).to have_content "コメントを追加しました！"
        click_link "削除", href: comment_path(Comment.last)
        expect(page).not_to have_selector 'span', text: '美味しい'
        expect(page).to have_content "コメントを削除しました"
      end
    end
  end

  describe "料理編集ページ" do
    before do
      sign_in user
      visit dish_path(dish)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('料理情報の編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content '料理名'
        expect(page).to have_content '説明'
        expect(page).to have_content '分量 [人分]'
        expect(page).to have_content 'コツ・ポイント'
        expect(page).to have_content '作り方'
        expect(page).to have_content '所要時間'
      end
    end

    context "料理の更新処理" do
      it "有効な更新" do
        fill_in "料理名", with: "編集：イカの塩焼き"
        fill_in "説明", with: "編集：冬に食べたくなる、身体が温まる料理です"
        fill_in "分量", with: 1
        fill_in "コツ・ポイント", with: "編集：ピリッと辛めに味付けするのがオススメ"
        fill_in "作り方", with: "切って煮る"
        fill_in "所要時間", with: 10
        click_button "更新する"
        expect(page).to have_content "料理情報が更新されました！"
        expect(dish.reload.name).to eq "編集：イカの塩焼き"
        expect(dish.reload.description).to eq "編集：冬に食べたくなる、身体が温まる料理です"
        expect(dish.reload.portion).to eq 1
        expect(dish.reload.tips).to eq "編集：ピリッと辛めに味付けするのがオススメ"
        expect(dish.reload.way_of_cooking).to eq "切って煮る"
        expect(dish.reload.required_time).to eq 10
      end
    end
  end

  describe "検索機能" do
    context "ログインしている場合" do
      before do
        sign_in user
        visit root_path
      end

      it "ログイン後の各ページに検索窓が表示されていること" do
        expect(page).to have_css 'form#dish_search'
        visit user_path(user)
        expect(page).to have_css 'form#dish_search'
        visit edit_user_registration_path(user)
        expect(page).to have_css 'form#dish_search'
        visit following_user_path(user)
        expect(page).to have_css 'form#dish_search'
        visit followers_user_path(user)
        expect(page).to have_css 'form#dish_search'
        visit dish_path(dish)
        expect(page).to have_css 'form#dish_search'
        visit new_dish_path
        expect(page).to have_css 'form#dish_search'
        visit edit_dish_path(dish)
      end
    end
  end
end
