class AddLikeCommentToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :like, :integer, default: 0
    add_column :articles, :comment, :integer, default: 0
  end
end
