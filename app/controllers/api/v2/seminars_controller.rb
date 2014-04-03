class Api::V2::SeminarsController < Api::V2::BaseController

  respond_to :json

  def index
    @seminars = Seminar.all
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
    @seminars = @seminars.includes({categorisations: [:category]}).where(categories: {id: params[:categories].split(',')}) if params[:categories]
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
    @seminars = @seminars.limit(200) if @seminars.count > 200
    respond_with @seminars do |format|
      format.json do
        render json: @seminars, each_serializer: SeminarSerializer
      end
      format.xml {
        render "index.xml.builder", layout: false
      }
      format.atom {
        render layout: false
      }
      format.rss {
        render layout: false
      }
      # format.ics {
      #   render layout: false
      # }
      format.ics do
        send_data(ics_data(@seminars).to_ical, file_name: 'bioseminars.ics', disposition: 'inline; filename=bioseminars.ics', type: 'text/calendar')
      end
    end
  end

  def show

  end

protected

  def ics_data(seminars)
    ical = Icalendar::Calendar.new
    # ical.add_x_property 'X-WR-CALNAME',@room.name
    seminars.each do |seminar|
      seminar.alarm = params['alarm']
      ical.event do |event|
        event.summary = "#{seminar.categories.map(&:acronym).compact.join(', ')} – #{seminar.title}"
        event.dtstart = seminar.start_at
        event.dtend = seminar.end_at
        event.location = seminar.location.name_and_building unless seminar.location.blank?
        description = []
        description << seminar.speaker_name_and_affiliation
        description << "Hosted by "+seminar.hosts.map(&:name).join(', ')
        event.description = description.join(' | ')
        event.url = ember_url(seminar)
        if seminar.alarm.present? && seminar.alarm.to_i >= 0
          event.alarm do |a|
            a.trigger = "-PT#{seminar.alarm}M"
            a.description = "#{seminar.categories.map(&:acronym).compact.join(', ')} – #{seminar.title}"
            a.action = 'DISPLAY'
          end
        end
      end
    end
    return ical
  end

private

  def current_resource
    @current_resource ||= (params[:id] ? Seminar.find(params[:id]) : Seminar.all)
  end
end
