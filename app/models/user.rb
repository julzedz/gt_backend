class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

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
  validates :fullname, presence: true
  validates :address, presence: true
end
