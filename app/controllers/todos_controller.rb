class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  def index
    #@todos = Todo.all
    if params[:user_id]
      @todos = Todo.where(user_id: params[:user_id])
    else
      @todos = Todo.all
    end
    render json: @todos
  end

  def show
    json_response(@todo)
  end

  def create
    @todo = Todo.create!(todo_params)

    if @todo.save
      render json: @todo, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(update_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :completed, :category, :user_id)
  end

  def update_params
    params.require(:todo).permit(:title, :description, :due_date, :completed, :category)
  end
end
