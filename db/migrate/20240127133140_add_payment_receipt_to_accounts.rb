class AddPaymentReceiptToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :payment_receipt, :string
  end
end
