require 'jwt'

module Authenticable
  def encode_token(payload)
    secret_key_base = Rails.application.credentials.secret_key_base
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def current_user
    @current_user ||= User.find_by(id: decoded_auth_token['user_id'].to_i) if decoded_auth_token
  end

  def authenticate_with_token!
    raise 'Not authenticated' unless current_user
  end

  def decoded_auth_token
    @decoded_auth_token ||= begin
      secret_key_base = Rails.application.credentials.secret_key_base
      decoded_token = JWT.decode(http_token, secret_key_base)[0]
      decoded_token
    rescue JWT::DecodeError => e
      nil
    end
  end

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
    end
  end
end
