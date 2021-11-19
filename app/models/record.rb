class Record < ApplicationRecord
  belongs_to :dish
  default_scope -> { order(created_at: :desc) }
  validates :dish_id, presence: true
end
