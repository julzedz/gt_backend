class User < ApplicationRecord
    
    has_one :account
    before_save :set_address
    before_create :generate_account_number
    
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true

  private

  def set_address
    self.address = "#{city}, #{state}, #{country}"
  end

  def generate_account_number
    self.account_number = rand(1_000_000_000..9_999_999_999)
  end
end
