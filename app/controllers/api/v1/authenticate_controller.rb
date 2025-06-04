module Api
  module V1
    class AuthenticateController < ApplicationController
      before_action :authenticate_request, except: [:login, :verify_otp, :resend_otp]

      # POST /login
      def login
        @user = User.find_by(email: login_params[:email])
        if @user&.authenticate(login_params[:password])
          # Generate and send OTP
          otp = generate_otp
          @user.update(otp_code: otp, otp_sent_at: Time.current)
          send_otp_to_user(@user, otp)
          
          render json: { message: 'OTP sent to your email' }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      # POST /verify-otp
      def verify_otp
        @user = User.find_by(email: otp_params[:email])
        
        if @user.nil?
          render json: { error: 'User not found' }, status: :not_found
          return
        end

        if verify_otp_and_expire(@user, otp_params[:otp])
          token = JsonWebToken.encode(user_id: @user.id)
          time = Time.now + 20.minutes.to_i
          render json: { 
            token: token, 
            exp: time.strftime('%m-%d-%Y %H:%M'),
            user: @user.as_json(include: :account)
          }, status: :ok
        else
          render json: { error: 'Invalid or expired OTP' }, status: :unauthorized
        end
      end

      # POST /resend-otp
      def resend_otp
        @user = User.find_by(email: resend_otp_params[:email])
        if @user
          otp = generate_otp
          @user.update(otp_code: otp, otp_sent_at: Time.current)
          send_otp_to_user(@user, otp)
          render json: { message: 'New OTP sent to your email' }, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end

      def otp_params
        params.permit(:email, :otp)
      end

      def resend_otp_params
        params.permit(:email)
      end

      def generate_otp
        # Generate a 4-digit OTP
        sprintf('%04d', rand(10000))
      end

      def send_otp_to_user(user, otp)
        OtpMailer.with(user: user, otp: otp).otp_email.deliver_now
      end

      def verify_otp_and_expire(user, otp_code)
        return false unless user && user.otp_code == otp_code
        
        # Check if OTP is expired (5 minutes)
        if user.otp_sent_at && user.otp_sent_at > 5.minutes.ago
          # Clear OTP after successful verification
          user.update(otp_code: nil, otp_sent_at: nil)
          true
        else
          false
        end
      end
    end
  end
end
