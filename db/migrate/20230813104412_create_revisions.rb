class CreateRevisions < ActiveRecord::Migration[7.0]
  def change
    create_table :revisions do |t|
      t.string :action
      t.integer :user_id
      t.timestamps
    end
  end
end
