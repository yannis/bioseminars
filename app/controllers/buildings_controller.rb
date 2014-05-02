class BuildingsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    respond_with @buildings.includes(:locations)
  end

  def show
    respond_with @building
  end

  def create
    if @building.save
      render json: @building, status: :created, location: @building
    else
      render json: {errors: @building.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @building.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @building.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @building.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user
        if current_user.admin?
          params.require(:building).permit!
        elsif current_user.member?
          params.require(:building).permit(:name)
        end
      end
    end
end
