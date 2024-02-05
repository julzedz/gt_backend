class Api::V1::UsersController < ApplicationController
  include JsonWebToken
  # before_action :authenticate_with_token!, except: [ :create]
  before_action :authenticate_request, except: [ :create, :show]

  rescue_from 'Not authenticated' do |exception|
    render json: { errors: [exception.message] }, status: :unauthorized
  end

# POST /api/v1/users
  def create
    @user = User.new(user_params)
    # ... save the user and associated account
    if @user.save
      @user.create_account # Automatically create associated account
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 7.days.to_i
      render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'), user: @user, include: :account }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/me
  def show_current
    # authenticate_request
    @user = User.find(params[:id])
    render json: @user, include: :account, status: :ok, only: [:email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at]
  end

# # GET /api/v1/users/:id
  def show
    # authenticate_request
    @user = User.find(params[:id])
    render json: @user, include: :account, status: :ok, only: [:email, :phone_number, :first_name, :last_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at]
  end

private

  def user_params
    params.permit(:email, :password_confirmation, :password, :phone_number, :first_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number, :created_at)
  end

  def authenticate_request
    result = JsonWebToken.authenticate_request(request)
    if result[:errors]
      render json: { errors: result[:errors] }, status: result[:status]
    else
      @decoded = result
    end
  end
end
