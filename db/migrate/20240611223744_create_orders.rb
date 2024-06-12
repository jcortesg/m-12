class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :item_total, precision: 10, scale: 2, default: '0.0', null: false
      t.decimal :total, precision: 10, scale: 2, default: '0.0', null: false
      t.string :state
      t.datetime :completed_at
      t.decimal :payment_total, precision: 10, scale: 2, default: '0.0'
      t.integer :item_count, default: 0
      t.string :token, null: false
      t.timestamps
    end

    add_index :orders, :token, unique: true
  end
end
