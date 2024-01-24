# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :city
      t.string :state
      t.date :date_of_birth
      t.string :country
      t.string :profile_img_path

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true

    execute <<-SQL
      ALTER TABLE users
      ADD COLUMN fullname text GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED;
    SQL

    execute <<-SQL
      ALTER TABLE users
      ADD COLUMN address text GENERATED ALWAYS AS (city || ', ' || state || ', ' || country) STORED;
    SQL

    execute <<-SQL
      ALTER TABLE users
      ADD COLUMN account_number integer;
    SQL

    execute <<-SQL
      CREATE OR REPLACE FUNCTION generate_random_account_number()
      RETURNS integer AS
      $$
      BEGIN
        RETURN floor(random() * 900000000 + 100000000)::integer;
      END;
      $$
      LANGUAGE plpgsql;
    SQL

    execute <<-SQL
      CREATE OR REPLACE FUNCTION set_random_account_number()
      RETURNS TRIGGER AS $$
      BEGIN
        NEW.account_number := generate_random_account_number();
        RETURN NEW;
      END;
      $$
      LANGUAGE plpgsql;
    SQL

    execute <<-SQL
      CREATE TRIGGER set_account_number
      BEFORE INSERT ON users
      FOR EACH ROW
      EXECUTE FUNCTION set_random_account_number();
    SQL
  end
end
