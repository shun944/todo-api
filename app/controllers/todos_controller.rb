class TodosController < ApplicationController
  before_action :set_todo, only: [:update, :destroy]
  before_action :set_todo_with_category, only: [:show]

  def index
    conditions = TodoSearchService.build_conditions(params)
    limit = params[:limit].to_i
    @todos = Todo.where(conditions.reduce(:and))
    @todos = @todos.limit(limit) if limit.positive?
    @todos = @todos.order(due_date: :desc).map(&:with_category)

    render json: @todos
  end

  def show
    json_response(@todo)
  end

  def create
    @todo = Todo.create!(todo_params)

    if @todo.save
      render json: @todo.with_category, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  def update
    if @todo.update(update_params)
      render json: @todo.with_category
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

  def set_todo_with_category
    @todo = Todo.find(params[:id])
    category = @todo.category_master.category_name
    @todo = @todo.attributes
    @todo["category"] = category
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due_date, :completed, :category_master_id, :user_id, :start_date)
  end

  def update_params
    params.require(:todo).permit(:title, :description, :due_date, :completed, :category_master_id, :start_date)
  end
end
