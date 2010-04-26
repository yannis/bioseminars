class SeminarsController < ApplicationController
  
  skip_before_filter :login_required, :only => ['index', 'calendar', 'show', 'load_publications']
  before_filter :basic_or_admin_required, :only => ['new', 'edit', 'create', 'update', 'destroy']
  before_filter :set_variables
  before_filter :set_next_seminar, :only => ['index', 'show', 'calendar']
  
  # GET /seminars
  # GET /seminars.xml
  def index
    @categories = Category.all
    begin
      @categories_to_show = Category.find(params[:categories].split(' ').map{|i| i if i.match(/\d+/)}.compact) if params[:categories]
    rescue
      @categories_to_show = Category.all
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
    query << "of_categories(@categories_to_show)" if !@categories_to_show.blank?
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
    
    respond_to do |format|
      format.html {
        @seminars = eval(@query).paginate(:page => params[:page])
        @seminars = @seminars.paginate(:page => '1') and params[:page] = '1' if @seminars.size == 0
      }
      format.xml  {
        @seminars = eval(@query)
        render :template => false
      }
      format.json  {
        @seminars = eval(@query)
        render :json => {:name => "David"}.to_json
      }
      format.rss  {
        @seminars = eval(@query)
        render :layout => false
      }
      format.ics {
        @seminars = eval(@query)
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
    @categories_to_show = Category.find(params[:categories].split(' ')) unless params[:categories].blank?
    @internal = params[:internal] == 'true' ? true : false
    @seminars = @categories_to_show.nil? ? Seminar.of_month(@date).all_day_first : Seminar.of_month(@date).of_categories(@categories_to_show).all_day_first
    @seminars_for_feeds = @categories_to_show.nil? ? Seminar.find(:all) : Seminar.of_categories(@categories_to_show)
    @days_with_seminars = @seminars.map{|s| s.days}.flatten.compact.uniq
    
    respond_to do |format|
      format.html
      format.iframe  { render 'iframe', :layout => 'layouts/iframe' }
    end
  end

  # GET /seminars/1
  # GET /seminars/1.xml
  def show
    @seminar = Seminar.find(params[:id])

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

  # GET /seminars/new
  # GET /seminars/new.xml
  def new
    @seminar = Seminar.new
    @seminar.start_on = params[:origin] ? params[:origin].to_time(:local) : Time.current
    @seminar.hosts.build
    @seminar.speakers.build

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @seminar }
      format.js{
        @origin = params[:origin]
        render :template => 'layouts/new.rjs'
      }
    end
  end

  # GET /seminars/1/edit
  def edit
    @seminar = Seminar.all_for_user(current_user).find(params[:id])
  end

  # POST /seminars
  # POST /seminars.xml
  def create
    params[:seminar] = params[:seminar].delete_if{|key, value| key == 'host_ids' and value == [""]  }
    @seminar = current_user.seminars.new(params[:seminar])
    respond_to do |format|
      if @seminar.save
        flash[:notice] = 'Seminar was successfully created.'
        format.html { redirect_to(@seminar) }
        format.xml  { render :xml => @seminar, :status => :created, :location => @seminar }
        format.js{
          @origin = params[:origin]
        }
      else
        flash[:warning] = @seminar.errors.full_messages.to_sentence
        format.html { render :action => "new" }
        format.xml  { render :xml => @seminar.errors, :status => :unprocessable_entity }
        format.js{
          @origin = params[:origin]
          render :template => 'layouts/new.rjs'
        }
      end
    end
    rescue Exception => e
      flash[:warning] = e ? e : (@seminar.errors.blank? ? 'Seminar not saved.' :  @seminar.errors.full_messages.to_sentence)
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

  # PUT /seminars/1
  # PUT /seminars/1.xml
  def update
    params[:seminar] = params[:seminar].delete_if{|key, value| key == 'host_ids' and value == [""]  }
    @seminar = Seminar.all_for_user(current_user).find(params[:id])
    respond_to do |format|
      if @seminar.update_attributes(params[:seminar])
        flash[:notice] = 'Seminar was successfully updated.'
        format.html { redirect_to(@seminar) }
        format.xml  { head :ok }
      else
        # flash[:warning] = 'Seminar not updated.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @seminar.errors, :status => :unprocessable_entity }
      end
    end

  end

  # DELETE /seminars/1
  # DELETE /seminars/1.xml
  def destroy
    @seminar = Seminar.all_for_user(current_user).find(params[:id])
    @seminar.destroy
    flash[:notice] = 'Seminar was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to(seminars_url) }
      format.xml  { head :ok }
      format.js { render 'layouts/remove_from_table' }
    end
  rescue Exception => e
    flash[:warning] = (e ? e.message : 'Seminar not deleted.')
    respond_to do |format|
      format.html { redirect_to((@seminar.nil? ? seminars_url : seminar_url(@seminar))) }
      format.xml  { head :ok }
      format.js { render 'layouts/remove_from_table' }
    end
  end
  
  def load_publications
    @seminar = Seminar.find(params[:id])
    @publications = @seminar.publications
    respond_to do |format|
      format.js
    end
  end
  
  def validate_pubmed_ids
    pubmed_ids = params[:pubmed_ids]
    @messages = []
    entries = Bio::PubMed.efetch(pubmed_ids.scan(/\d+/).map{|e| e.to_i})# searches PubMed and get entry
    for entry in entries
      publication = Bio::MEDLINE.new(entry)
      unless publication.title.blank? and publication.authors.blank? and publication.journal.blank?
        @messages << publication
      else
        @messages << 'invalid'
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
  def about
    
  end
  
  protected
  
  def set_variables
    @buildings = Building.find :all
    @categories = Category.find(:all)
    @next_seminar = Seminar.next.first
  end
  
  def set_next_seminar
    @next_seminar = Seminar.next.first
  end
end
