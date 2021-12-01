require 'rails_helper'

RSpec.describe Record, type: :model do
  let!(:record) { create(:record) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(record).to be_valid
    end

    it "dish_idがなければ無効な状態であること" do
      record = build(:record, dish_id: nil)
      expect(record).not_to be_valid
    end
  end
end
