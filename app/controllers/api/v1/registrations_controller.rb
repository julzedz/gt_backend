class Api::V1::RegistrationsController < ApplicationController
  include Authenticable

  # POST /api/v1/registrations
  def create
    @user = User.new(registration_params)

    if @user.save
      token = encode_token(user_id: @user.id)
      @user.create_account # Automatically create associated account
      render json: { user: @user, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:email, :password, :password_confirmation, :first_name, :last_name, :date_of_birth, :phone_number, :city, :state, :country)
  end
end
