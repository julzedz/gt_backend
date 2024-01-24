class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :savings_account
      t.decimal :investment
      t.decimal :earnings
      t.decimal :stakes

      t.timestamps
    end
  end
end
