class Api::V1::RegistrationsController < ApplicationController
  include Authenticable

  # POST /api/v1/registrations
  def create
    @user = User.new(user_params)

    if @user.save
      @user.create_account # Automatically create associated account
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :first_name, :last_name, :date_of_birth, :phone_number, :city, :state, :country)
  end
end
