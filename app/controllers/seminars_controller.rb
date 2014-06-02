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

    # to redirect legacy requests
    old_params = {}
    old_params[:categories] = params[:categories].split(' ').join(',') if params[:categories]
    old_params[:scope] = params[:scope] if params[:scope]
    old_params[:order] = params[:order] if params[:order]
    old_params[:limit] = params[:limit] if params[:limit]
    old_params[:before] = params[:before] if params[:before]
    old_params[:after] = params[:after] if params[:after]
    old_params[:internal] = params[:internal] if params[:internal]

    respond_with @seminars do |format|
      format.rss {
        old_params.merge! format: 'rss'
        redirect_to api_v2_seminars_path(old_params), status: 301
      }
      format.ics {
        old_params.merge! format: 'ics'
        redirect_to api_v2_seminars_path(old_params), status: 301
      }
    end
  end

  def show
    respond_with @seminar do |format|
      format.html {
        redirect_to @seminar.ember_path, status: 301
      }
      format.ics {
        redirect_to api_v2_seminar_path(@seminar, format: 'ics'), status: 301
      }
    end
  end

  def create
    @seminar.user = current_user if @seminar.user.blank?
    if @seminar.save
      render json: @seminar, status: :created, location: @seminar
    else
      render json: {errors: @seminar.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @seminar.update_attributes sanitizer
      render json: nil, status: :ok
    else
      render json: {errors: @seminar.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @seminar.destroy
    render json: nil, status: :ok
  end

  private

  def sanitizer
    if current_user
      Rails.logger.debug "current_user member?: #{current_user.member?}"
      if current_user.admin?
        params.require(:seminar).permit!
      elsif current_user.member?
        params.require(:seminar).permit(:title, {host_ids: []}, {category_ids: []}, :speaker_name, :speaker_affiliation, :start_at, :end_at, :location_id, :url, :pubmed_ids, :all_day, :documents_attributes, :internal, :description)
      end
    end
  end
end
