class ChangeAccountNumberType < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :account_number, :bigint
  end
end
