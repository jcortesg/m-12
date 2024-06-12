class AddClientToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :client, null: true, foreign_key: true
  end
end
