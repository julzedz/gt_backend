class Api::V1::SessionsController < ApplicationController
  include Authenticable

    # POST /api/v1/sessions
  def create
    @user = User.find_by(email: params[:email])

    if @user&.valid_password?(params[:password])
      sign_in @user
      render json: @user, status: :ok
    else
      render json: { errors: ['Invalid email or password'] }, status: :unauthorized
    end
  end

    # DELETE /api/v1/sessions
  def destroy
    sign_out
    head :no_content
  end
end
