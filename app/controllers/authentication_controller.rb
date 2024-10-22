class AuthenticationController < ApplicationController
  def login
    # @user = User.find_by_username(params[:username])
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      puts '///////////////////////////////'
      puts params
      puts '///////////////////////////////'
      render json: { token: token, id: @user.id, username: @user.username }
    else
      render json: { error: 'Invalid email or password' }
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

end
