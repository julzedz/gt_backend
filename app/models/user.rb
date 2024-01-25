class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
    # :token_authenticatable
    
    has_one :account, validate: true
    before_save :set_address
    before_create :generate_account_number
    
# Override password setter method to store plain text password in the database
  def password=(new_password)
    @password = new_password
    self.encrypted_password = Devise.bcrypt(self.class, new_password) unless Rails.env.development?
  end

# Override password getter method to return plain text password
  def password
    @password
  end

  # Override password_digest to return plain text password
  def password_digest(password)
    password
  end


  has_one :account
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validates :phone_number, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :profile_img_path, presence: true

  private

  def set_address
    self.address = "#{city}, #{state}, #{country}"
  end

  def generate_account_number
    self.account_number = rand(1_000_000_000..9_999_999_999)
  end
end
