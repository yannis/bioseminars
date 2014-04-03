class CategoriesController < ApplicationController

  def index
    @categories = @current_resource
    respond_with @categories
  end

  def show
    @category = @current_resource
    respond_with @category
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  def update
    @category = @current_resource
    if @category.update_attributes(params[:category])
      render json: nil, status: :ok
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @category = @current_resource
    @category.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? Category.includes(:seminars).find(params[:id]) : Category.includes(:seminars).order("categories.position ASC")
  end
end
