class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error

  def show
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
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:todo).permit(:username, :email, :password)
  end

  def update_params
    params.require(:todo).permit(:email, :password)
  end

  def handle_parameter_missing(e)
    render json: { message: e.message }, status: 400
  end

  def handle_validation_error(e)
    render json: { message: e }, status: 400
  end
end
