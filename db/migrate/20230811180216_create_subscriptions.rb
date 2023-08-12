class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :membership
      t.integer :amount
      t.date :expiry
      t.timestamps
    end
  end
end
