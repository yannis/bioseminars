class CategoriesController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    @categories = @categories.active unless current_user && current_user.admin?

    respond_with @categories
  end

  def show
    respond_with @category
  end

  def create
    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @category.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @category.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user
        if current_user.admin?
          params.require(:category).permit!
        elsif current_user.member?
          params.require(:category).permit(:name, :description, :acronym, :color)
        end
      end
    end
end
