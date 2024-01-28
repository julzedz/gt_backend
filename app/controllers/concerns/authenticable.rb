require 'jwt'

module Authenticable
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def current_user
    @current_user ||= User.find_by(id: decoded_auth_token[:user_id]) if decoded_auth_token
  end

  def authenticate_with_token!
    render json: { errors: ['Not authenticated'] }, status: :unauthorized unless current_user
  end

  def decoded_auth_token
    @decoded_auth_token ||= JWT.decode(http_token, Rails.application.secrets.secret_key_base).first
  end

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end
end
