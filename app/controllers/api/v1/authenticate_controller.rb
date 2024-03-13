module Api
  module V1
    class AuthenticateController < ApplicationController
      # your code here
      before_action :authenticate_request, except: :login

      # POST /login
      def login
        @user = User.find_by(email: login_params[:email])
        if @user&.authenticate(login_params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 20.minutes.to_i
          render json: { token: token, exp: time.strftime('%m-%d-%Y %H:%M'),
            user: @user.as_json(include: :account) }, status: :ok 
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit( :email, :password )
      end
    end
  end
end
