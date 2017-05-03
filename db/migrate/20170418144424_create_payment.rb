class CreatePayment < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :amount
      t.integer :currency_id
      t.string :description
      t.integer :payment_address_id
      t.integer :member_id
      t.string :status
    end
  end
end
