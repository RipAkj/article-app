class CreateSaveForLaters < ActiveRecord::Migration[7.0]
  def change
    create_table :save_for_laters do |t|
      t.integer :user_id
      t.integer :article_id
      t.timestamps
    end
  end
end
