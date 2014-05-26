class HostingsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def create
    if @hosting.save
      render json: @hosting, status: :created, location: @hosting
    else
      render json: {errors: @hosting.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @hosting.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @hosting.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @hosting.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user
        if current_user.admin?
          params.require(:hosting).permit!
        elsif current_user.member?
          params.require(:hosting).permit(:host_id, :seminar_id)
        end
      end
    end
end
