class HostsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    respond_with @hosts.includes(hostings: :seminar)
  end

  def show
    respond_with @host
  end

  def create
    if @host.save
      render json: @host, status: :created, location: @host
    else
      render json: {errors: @host.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @host.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @host.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @host.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user
        if current_user.admin?
          params.require(:host).permit!
        elsif current_user.member?
          params.require(:host).permit(:name, :email)
        end
      end
    end
end
