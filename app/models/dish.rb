class Dish < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 140 }
  validates :tips, length: { maximum: 50 }
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients
end
