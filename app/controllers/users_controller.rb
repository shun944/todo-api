class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :authenticate_request, only: [:show]
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error

  def show
    render json: @current_user
  end

  def create
    @user = User.create!(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(update_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def update_params
    params.require(:user).permit(:email, :password)
  end

  def handle_parameter_missing(e)
    render json: { message: e.message }, status: 400
  end

  def handle_validation_error(e)
    render json: { message: e }, status: 400
  end

  def authenticate_request
    token = request.headers['Authorization']
    decoded_token = decode_token(token)
    @current_user = User.find(decoded_token[0]['user_id']) if decoded_token
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def decode_token(token)
    begin
      token = token.gsub('Bearer ', '')
      puts '///////////////////////////////////////'
      puts token
      puts '///////////////////////////////////////'
      JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
    rescue JWT::DecodeError
      nil
    end
  end
end
