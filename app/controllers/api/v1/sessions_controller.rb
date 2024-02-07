# class Api::V1::SessionsController < ApplicationController
#   include Authenticable

#     # POST /api/v1/sessions
#   def create
#     @user = User.find_by(email: params[:email])

#     if @user&.authenticate(params[:password])
#       token = encode_token(user_id: @user.id)
#       render json: { user: @user, token: token }, status: :ok
#     else
#       render json: { errors: ['Invalid email or password'] }, status: :unauthorized
#     end
#   end

#     # DELETE /api/v1/sessions
#   def destroy
#     render json: { message: 'Logged out' }, status: :ok
#   end
# end
