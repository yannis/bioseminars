class SeminarsController < ApplicationController

  load_and_authorize_resource param_method: :sanitizer

  def index
    @seminars = @seminars.page(params[:page]).per(params[:per_page]) if params[:page] && params[:per_page]
    @seminars = @seminars.where(:internal => [true, false]) if params[:internal] == 'true'
    if params[:order]
      @seminars = @seminars.order("seminars.start_at #{params[:order] == 'asc' ? 'ASC' : 'DESC'}")
    else
      @seminars = @seminars.order("seminars.start_at DESC")
    end
    if params[:user_id]
      @user = User.find params[:user_id]
      @seminars = @seminars.where(:user_id => @user.id)
      @title = "Seminars recorded by #{@user.name}"
    end
    if params[:limit] && params[:limit].to_i > 0
      @seminars = @seminars.limit(params[:limit])
    end
    if params[:ids]
      @seminars = @seminars.where(id: params[:ids])
    end
    @seminars = @seminars.includes({categorisations: [:category]}).where(categories: {id: params[:categories].split(' ')}) if params[:categories]
    if params[:scope] == 'future'
      @seminars = @seminars.now_or_future
    elsif params[:scope] == 'past'
      @seminars = @seminars.past
    end

    if params[:before] && Date.parse(params[:before])
      @seminars = @seminars.before_date(Date.parse(params['before']))
    end
    if params[:after] && Date.parse(params[:after])
      @seminars = @seminars.after_date(Date.parse(params['after']))
    end

    @seminars = @seminars.active unless current_user && current_user.admin?

    @seminars = @seminars.limit(200) if @seminars.count > 200

    respond_with @seminars
  end

  def show
    respond_with @seminar
  end

  def create
    @seminar.user = current_user if @seminar.user.blank?
    if @seminar.save
      render json: @seminar, status: :created, location: @seminar
    else
      render json: {message: @seminar.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @seminar.update_attributes sanitizer
      render json: nil, status: :ok
    else
      render json: {message: @seminar.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @seminar.destroy
    render json: nil, status: :ok
  end

  private

  def sanitizer
    if current_user
      if current_user.admin?
        params.require(:seminar).permit!
      elsif current_user.member?
        params.require(:seminar).permit(:title, :speaker_name, :speaker_affiliation, :start_at, :end_at, :location_id, :url, :pubmed_ids, :all_day, :hostings_attributes, :documents_attributes, :internal, :description, {hostings: [:host_id, :seminar_id, :id]}, {categorisations: [:category_id, :seminar_id, :id]})
      end
    end
  end
end
