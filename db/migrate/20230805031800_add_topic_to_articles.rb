class AddTopicToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :topic, :string, default: ""
  end
end
