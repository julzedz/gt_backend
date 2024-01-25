class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

# POST 
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

    render json: @user, status: :okay, only: [:email, :phone_number, :first_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number]
  end

# GET /api/v1/users/:id
  def show
    @user = User.find(params[:id])

    # Adjust fields based on access control/visibility preferences
    render json: @user, only: [:email, :phone_number, :first_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number]
  end

private

  def user_params
    params.permit(:email, :phone_number, :first_name, :date_of_birth, :city, :state, :country, :profile_img_path, :address, :fullname, :account_number)
  end
end
