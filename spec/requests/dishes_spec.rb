require "rails_helper"

RSpec.describe "Dishes", type: :request do
  describe "料理個別ページ" do
    let!(:user) { create(:user) }
    let!(:dish) { create(:dish, user: user) }

    context "認可されたユーザーの場合" do
      it "レスポンスが正常に表示されること" do
        sign_in user
        get dish_path(dish)
        expect(response).to have_http_status "200"
        expect(response).to render_template('dishes/show')
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面にリダイレクトすること" do
        get dish_path(dish)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "料理編集" do
    let!(:user) { create(:user) }
    let!(:dish) { create(:dish, user: user) }
    let(:picture1_path) { File.join(Rails.root, 'spec/fixtures/test_dish1.jpg') }
    let(:picture1) { Rack::Test::UploadedFile.new(picture1_path) }

    context "認可されたユーザーの場合" do
      it "レスポンスが正常に表示されること" do
        sign_in user
        get edit_dish_path(dish)
        expect(response).to render_template('dishes/edit')
        patch dish_path(dish), params: { dish: { name: "イカの塩焼き",
                                                 description: "冬に食べたくなる、身体が温まる料理です",
                                                 portion: 1,
                                                 tips: "ピリッと辛めに味付けするのがオススメ",
                                                 way_of_cooking: "切って煮る",
                                                 required_time: 30,
                                                 picture: picture1 } }
        redirect_to dish
        follow_redirect!
        expect(response).to render_template('dishes/show')
      end
    end
  end
end
