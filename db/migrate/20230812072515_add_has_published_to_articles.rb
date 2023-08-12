class AddHasPublishedToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :has_published, :boolean, default: false
  end
end
