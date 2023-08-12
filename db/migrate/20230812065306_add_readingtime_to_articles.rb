class AddReadingtimeToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :readingtime, :string
  end
end
