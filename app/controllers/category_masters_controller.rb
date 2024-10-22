class CategoryMastersController < ApplicationController

  def index
    @category = CategoryMaster.all

    render json: @category
  end

  def create
    @category = CategoryMaster.create!(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:category_name)
  end
end
