class BuildingsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    respond_with @buildings.includes(:locations)
  end

  def show
    respond_with @building
  end

  def create
    @building.save
    respond_with @building
  end

  def update
    @building.update_attributes(sanitizer)
    respond_with @building
  end

  def destroy
    @building.destroy
    respond_with @building
    # render json: nil, status: :ok
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
