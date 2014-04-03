class HostingsController < ApplicationController
  def create
    @hosting = Hosting.new(params[:hosting])
    if @hosting.save
      render json: @hosting, status: :created, location: @hosting
    else
      render json: {errors: @hosting.errors}, status: :unprocessable_entity
    end
  end

  def update
    @hosting = @current_resource
    if @hosting.update_attributes(params[:hosting])
      render json: nil, status: :ok
    else
      render json: {errors: @hosting.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @hosting = @current_resource
    @hosting.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? Hosting.find(params[:id]) : Hosting.all
  end
end
