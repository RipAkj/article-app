class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save { self.email = email.downcase}
  has_many :articles
  has_many :comments
  has_many :viewed_articles
  has_many :subscriptions
  has_many :lists, dependent: :destroy
  has_many :save_for_laters
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum:1 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
  uniqueness: { case_sensitive: false },
  length: { maximum:105 },
  format: { with: VALID_EMAIL_REGEX }
  has_many :active_friendships, class_name:"Friendship", foreign_key:"follower_id", dependent: :destroy
  has_many :passive_friendships, class_name:"Friendship", foreign_key:"followed_id", dependent: :destroy
  has_many :following, through: :active_friendships, source: :followed
  has_many :followers, through: :passive_friendships, source: :follower
  # user1.follow(user2)
  # user2.followers.include?(user1)
  def follow(user)
    active_friendships.create(followed_id: user.id)
  end
  def unfollow(user)
    active_friendships.find_by(followed_id: user.id).destroy
  end
  def following?(user)
    following.include?(user)
  end
end
