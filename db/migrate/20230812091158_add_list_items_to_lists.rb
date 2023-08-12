class AddListItemsToLists < ActiveRecord::Migration[7.0]
  def change
    add_column :lists, :list_items, :integer, array: true, default: []
  end
end
