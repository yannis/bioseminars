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
    categories = Category.includes(:seminars)
    # Rails.logger.debug "current_user: #{current_user.admin}"
    categories = categories.where("categories.archived_at IS NULL") unless current_user.present? && current_user.admin
    @current_resource ||= params[:id] ? Category.includes(:seminars).find(params[:id]) : categories.order("categories.position ASC")
  end
end
