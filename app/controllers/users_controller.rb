class UsersController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :handle_parameter_missing

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
  end

  def destroy
  end

  def user_params
    params.require(:todo).permit(:username, :email, :password)
  end

  def handle_parameter_missing(e)
    render json: { message: e }, status: 400
  end
end
