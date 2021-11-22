class User < ApplicationRecord
  has_many :dishes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  mount_uploader :profile_photo, PictureUploader
  has_many :lists, dependent: :destroy
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def feed
    Dish.all
  end

  def favorite(dish)
    Favorite.create!(user_id: id, dish_id: dish.id)
  end

  def unfavorite(dish)
    Favorite.find_by(user_id: id, dish_id: dish.id).destroy
  end

  def favorite?(dish)
    !Favorite.find_by(user_id: id, dish_id: dish.id).nil?
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def list(dish)
    List.create!(user_id: dish.user_id, dish_id: dish.id)
  end

  def unlist(list)
    list.destroy
  end

  def list?(dish)
    !List.find_by(dish_id: dish.id).nil?
  end
end
