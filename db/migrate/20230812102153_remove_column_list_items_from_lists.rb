class RemoveColumnListItemsFromLists < ActiveRecord::Migration[7.0]
  def change
    remove_column :lists, :list_items
  end
end
