class AddListToListItems < ActiveRecord::Migration[7.0]
  def change
    add_column :list_items, :list_id, :int
    add_column :list_items, :article_id, :int
  end
end
