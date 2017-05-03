class AddOrderNumberToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :order_number, :string
  end
end
