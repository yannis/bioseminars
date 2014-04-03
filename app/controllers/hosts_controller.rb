class HostsController < ApplicationController

  def index
    @hosts = @current_resource
    respond_with @hosts
  end

  def show
    @host = @current_resource
    respond_with @host
  end

  def create
    @host = Host.new(params[:host])
    if @host.save
      render json: @host, status: :created, location: @host
    else
      render json: {errors: @host.errors}, status: :unprocessable_entity
    end
  end

  def update
    @host = @current_resource
    if @host.update_attributes(params[:host])
      render json: nil, status: :ok
    else
      render json: {errors: @host.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @host = @current_resource
    @host.destroy
    render json: nil, status: :ok
  end

private

  def current_resource
    @current_resource ||= params[:id] ? Host.find(params[:id]) : Host.all
  end
end
