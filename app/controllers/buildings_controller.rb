class BuildingsController < ApplicationController

  def index
    @buildings = @current_resource
    respond_with @current_resource.includes(:locations)
  end

  def show
    @building = @current_resource
    respond_with @building
  end

  def create
    @building = Building.new(params[:building])
    if @building.save
      render json: @building, status: :created, location: @building
    else
      render json: {errors: @building.errors}, status: :unprocessable_entity
    end
  end

  def update
    @building = @current_resource
    if @building.update_attributes(params[:building])
      render json: nil, status: :ok
    else
      render json: {errors: @building.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @building = @current_resource
    @building.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? Building.find(params[:id]) : Building.all
  end
end
