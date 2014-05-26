class LocationsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    respond_with @locations.includes({building: [:locations]}, :seminars)
  end

  def show
    respond_with @location
  end

  def create
    if @location.save
      render json: @location, status: :created, location: @location
    else
      render json: {errors: @location.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @location.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @location.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user
        if current_user.admin?
          params.require(:location).permit!
        elsif current_user.member?
          params.require(:location).permit(:name, :building_id)
        end
      end
    end
end
