class CategorisationsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def create
    if @categorisation.save
      render json: @categorisation, status: :created, location: @categorisation
    else
      render json: {errors: @categorisation.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @categorisation.update_attributes(sanitizer)
      render json: nil, status: :ok
    else
      render json: {errors: @categorisation.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @categorisation.destroy
    render json: nil, status: :ok
  end

  private

    def sanitizer
      if current_user
        if current_user.admin?
          params.require(:categorisation).permit!
        elsif current_user.member?
          params.require(:categorisation).permit(:category_id, :seminar_id)
        end
      end
    end
end
