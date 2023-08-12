class Article < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes
  has_many :list_items, dependent: :destroy
  has_many :lists, through: :list_items
  has_many :save_for_laters, dependent: :destroy
  validates :title, presence: true#, length: {minimum:6, maximum:100}
  validates :description, presence: true
end
