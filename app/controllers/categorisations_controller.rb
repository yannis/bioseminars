class CategorisationsController < ApplicationController
  def create
    @categorisation = Categorisation.new(params[:categorisation])
    if @categorisation.save
      render json: @categorisation, status: :created, location: @categorisation
    else
      render json: {errors: @categorisation.errors}, status: :unprocessable_entity
    end
  end

  def update
    @categorisation = @current_resource
    if @categorisation.update_attributes(params[:categorisation])
      render json: nil, status: :ok
    else
      render json: {errors: @categorisation.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @categorisation = @current_resource
    @categorisation.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? Categorisation.find(params[:id]) : Categorisation.all
  end
end
