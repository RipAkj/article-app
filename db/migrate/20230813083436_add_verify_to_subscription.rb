class AddVerifyToSubscription < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :order_id, :string
    add_column :subscriptions, :verified, :boolean, default: false
  end
end
