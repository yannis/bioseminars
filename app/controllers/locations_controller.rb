class LocationsController < ApplicationController

  def index
    @locations = @current_resource
    respond_with @locations.includes({building: [:locations]}, :seminars)
  end

  def show
    @location = @current_resource
    respond_with @location
  end

  def create
    @location = Location.new(params[:location])
    if @location.save
      render json: @location, status: :created, location: @location
    else
      render json: {errors: @location.errors}, status: :unprocessable_entity
    end
  end

  def update
    @location = @current_resource
    if @location.update_attributes(params[:location])
      render json: nil, status: :ok
    else
      render json: {errors: @location.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @location = @current_resource
    @location.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? Location.find(params[:id]) : Location.all
  end
end
