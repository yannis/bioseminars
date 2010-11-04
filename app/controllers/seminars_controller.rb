class SeminarsController < ApplicationController
  
  before_filter :authenticate_user!, :only => ['new', 'create', 'edit', 'update', 'destroy']
  load_and_authorize_resource :except => ['calendar', 'validate_pubmed_ids', 'load_publications', 'about']
  before_filter :set_variables
  before_filter :set_next_seminar, :only => ['index', 'show', 'calendar']
  respond_to :html, :xml, :js, :atom, :ics, :iframe
  
  def index
    @categories = Category.all
    begin
      @categories_to_show = @categories.select{|c| params[:categories].split(' ').include?(c.id.to_s) } if params[:categories]
    rescue
      @categories_to_show = @categories
    end
    @internal = params[:internal] == 'true' ? true : false
    
    query = ['Seminar']
    if params[:order].blank?
      query << "sort_by_order('asc')"
    else 
      query << "sort_by_order(params['order'])"
    end
    if params[:user_id]
      query << 'all_for_user(current_user)'
      @title = "Seminars recorded by #{current_user.name}"
    end
    query << "of_categories(@categories_to_show)" unless @categories_to_show.blank?
    if params[:scope] == 'future'
      params[:scope] = 'future'
      query << "now_or_future"
    elsif params[:scope] == 'all'
      query << "all"
    elsif params[:scope] == 'past'
      query << "past"
    end
    query <<  "before_date(Date.parse(params['before']))" if params[:before] and Date.parse(params[:before])
    query << "after_date(Date.parse(params['after']))" if params[:after] and Date.parse(params[:after])
    query << 'all' if query.size == 1
    @query = query.join('.')
    
    @seminars = eval(@query)
    respond_with @seminars do |format|
      format.html {
        @seminars = @seminars.paginate(:page => params[:page])
        (@seminars = @seminars.paginate(:page => '1') and params[:page] = '1') if @seminars.size == 0
        @seminars_with_publication = @seminars.select{|s| !s.pubmed_ids.blank? }
      }
      # format.json  {
      #   @seminars = eval(@query)
      #   render :json => {:name => "David"}.to_json
      # }
      
      format.xml {
        render 'index', :layout => false
      }
      format.rss {
        render :layout => false
      }
      format.ics {
        cal = Icalendar::Calendar.new
        for seminar in @seminars
          cal_event = Icalendar::Event.new
          cal_event.start = seminar.start_on.to_s(:rfc2445) unless seminar.start_on.blank?
          cal_event.end = seminar.end_on.to_s(:rfc2445) unless seminar.end_on.blank?
          cal_event.location = seminar.location.name_and_building unless seminar.location.blank?
          summary = []
          summary << seminar.mini_seminar_title
          summary << seminar.speakers.map{|s| s.name_and_affiliation}
          summary << "Hosted by "+seminar.hosts.map(&:name).join(', ')
          cal_event.summary = summary.join(' | ')
          cal_event.url = seminar_url(seminar)
          cal_event.description = seminar.description unless seminar.description.blank?
          cal.add_event(cal_event.to_ical)
        end
        render :text => cal.to_ical
      }
    end
  end
  
  def calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @categories = Category.all
    @categories_to_show = Category.find(params[:categories].split(' ')-['internal']) unless params[:categories].blank?
    @internal = params[:internal] == 'true' ? true : false
    @seminars = @categories_to_show.nil? ? Seminar.of_month(@date).all_day_first : Seminar.of_month(@date).of_categories(@categories_to_show).all_day_first
    @seminars_for_feeds = @categories_to_show.nil? ? Seminar.find(:all) : Seminar.of_categories(@categories_to_show)
    @days_with_seminars = @seminars.map{|s| s.days}.flatten.compact.uniq
    
    respond_to do |format|
      format.html
      format.iframe  { render 'iframe', :layout => 'layouts/iframe' }
      format.js { render :layout => false}
    end
  end
  
  def show
    respond_to do |format|
      format.html {render 'show'}
      format.xml  {
        render :template => false
      }
      format.js {render 'mini_seminar', :layout => false}
      format.json  {
        render :json => @seminar.to_json
      }
      format.ics do
        cal_event = Icalendar::Event.new
        cal_event.start = @seminar.start_on.to_s(:rfc2445) unless @seminar.start_on.blank?
        cal_event.end = @seminar.end_on.to_s(:rfc2445) unless @seminar.end_on.blank?
        cal_event.location = @seminar.location.building.name + ", " + @seminar.location.name unless @seminar.location.blank?
        summary = []
        summary << @seminar.mini_seminar_title
        summary << @seminar.speakers.map{|s| s.name_and_affiliation}
        cal_event.summary = summary.join(' | ')
        cal_event.url = seminar_url(@seminar)
        description = []
        description << @seminar.description unless @seminar.description.blank?
        description << "Hosted by "+@seminar.hosts.map(&:name).join(', ')+'.'
        cal_event.description = description.join(' ')
        cal = Icalendar::Calendar.new
        cal.add_event(cal_event.to_ical)
        render :text => cal.to_ical
      end
    end
  end

  def new
    @seminar.start_on = params[:origin] ? params[:origin].to_time(:local) : Time.current.to_s(:day_month_year_hour_minute)
    @seminar.hostings.build
    @seminar.speakers.build

    respond_with @seminar do |format|
      format.js{
        @origin = params[:origin]
        render 'layouts/new.js.erb', :content_type => 'text/javascript', :layout => false
      }
    end
  end

  def edit
  end
  
  def create
    @seminar = current_user.seminars.new(params[:seminar])
    respond_to do |format|
      if @seminar.save
        flash[:notice] = 'Seminar was successfully created.'
        format.html { redirect_to(@seminar) }
        format.xml  { render :xml => @seminar, :status => :created, :location => @seminar }
        format.js{
          @origin = params[:origin]
          render :layout => false, :content_type => 'text/javascript', :layout => false
        }
      else
        flash[:alert] = @seminar.errors.full_messages.to_sentence
        format.html { render :action => "new" }
        format.xml  { render :xml => @seminar.errors, :status => :unprocessable_entity }
        format.js{
          @origin = params[:origin]
          render :template => 'layouts/new.rjs', :content_type => 'text/javascript', :layout => false
        }
      end
    end
    rescue Exception => e
      flash[:alert] = e ? e : (@seminar.errors.blank? ? 'Seminar not saved.' :  @seminar.errors.full_messages.to_sentence)
      unless @seminar.nil?
        @seminar.errors.add_to_base(e)
        respond_to do |format|
          format.html { render 'new' }
        end
      else
        
        respond_to do |format|
          format.html { redirect_back_or_default(seminars_path) }
        end       
      end
  end

  def update
    params[:seminar] = params[:seminar].delete_if{|key, value| key == 'host_ids' and value == [""]  }
    # params[:seminar][:host_ids].delete_if{|i| i == ""} if params[:seminar] and params[:seminar][:host_ids]
    # @seminar = Seminar.all_for_user(current_user).find(params[:id])
    if @seminar.update_attributes(params[:seminar])
      flash[:notice] = 'Seminar was successfully updated.' if @seminar.valid?
    end
    respond_with @seminar
  end
  
  def destroy
    @seminar.destroy
    flash[:notice] = 'Seminar was successfully deleted.'
    respond_with @seminar do |format|
      format.js {render 'destroy', :content_type => 'text/javascript', :layout => false}
    end
  rescue Exception => e
    flash[:alert] = (e ? e.message : 'Seminar not deleted.')
    respond_to do |format|
      format.html { redirect_to((@seminar.nil? ? seminars_url : seminar_url(@seminar))) }
      format.js {render :content_type => 'text/javascript', :layout => false}
    end
  end
  
  def load_publications
    @seminar = Seminar.find(params[:id])
    @publications = @seminar.publications
    respond_to do |format|
      format.js {render :content_type => 'text/javascript', :layout => false}
    end
  end
  
  def validate_pubmed_ids
    @messages = Seminar.validate_pubmed_ids(params[:pubmed_ids])
    respond_to do |format|
      format.js {render :content_type => 'text/javascript', :layout => false}
    end
  end
  
  def about
  end
  
  protected
  
  def set_variables
    @buildings = Building.all
    @categories = Category.all
    @next_seminar = Seminar.next.first
  end
  
  def set_next_seminar
    @next_seminar = Seminar.next.first
  end
end
