class Api::V1::UsersController < ApplicationController
include Authenticable
  before_action :authenticate_with_token!, except: [ :create]

  rescue_from 'Not authenticated' do |exception|
    render json: { errors: [exception.message] }, status: :unauthorized
  end

# POST /api/v1/users
  def create
    @user = User.new(user_params)
    # ... save the user and associated account
    if @user.save
      @user.create_account # Automatically create associated account
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
  end


  # GET /api/v1/users/me
  def show_current
    @user = current_user

    render json: @user, include: :account, status: :okay, only: [:email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at]
  end

# GET /api/v1/users/:id
  def show
    @user ||= User.find_by(id: decoded_auth_token['user_id'].to_i) if decoded_auth_token

    # Adjust fields based on access control/visibility preferences
    render json: @user, include: :account, only: [:email, :phone_number, :first_name, :last_name, :password, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at]
  end

private

  def user_params
    params.permit(:email, :password_confirmation, :password, :phone_number, :first_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at)
  end
end
