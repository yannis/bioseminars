class SeminarsController < ApplicationController
  
  skip_before_filter :login_required, :only => ['index', 'show']
  before_filter :set_variables
  # GET /seminars
  # GET /seminars.xml
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @seminars = Seminar.of_month(@date)
    @days_with_seminars = @seminars.map{|s| s.days}.flatten.compact.uniq

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @seminars }
      format.rss  { render :layout => false }
      format.ics do
        cal = Icalendar::Calendar.new
        @seminars.each do |seminar|
          cal_event = Icalendar::Event.new
          cal_event.start = seminar.start_on.to_s(:rfc2445) unless seminar.start_on.blank?
          cal_event.end = seminar.end_on.to_s(:rfc2445) unless seminar.end_on.blank?
          cal_event.location = seminar.location.building.name + ", " + seminar.location.name unless seminar.location.blank?
          summary = []
          summary << seminar.title
          summary << seminar.speakers.map{|s| s.name+' ('+s.affiliation+')'}
          summary << "Hosted by: "+seminar.hosts.map(&:name).join(', ')
          cal_event.summary = summary.join(' | ')
          cal_event.url = seminar_url(seminar)
          cal_event.description = seminar.description unless seminar.description.blank?
          cal.add_event(cal_event.to_ical)
        end
        render :text => cal.to_ical
      end
    end
  end

  # GET /seminars/1
  # GET /seminars/1.xml
  def show
    @seminar = Seminar.find(params[:id])

    respond_to do |format|
      format.html {render 'show'}
      format.xml  { render :xml => @seminar }
      format.js {render 'mini_seminar', :layout => false}
      format.ics do
        cal_event = Icalendar::Event.new
        cal_event.start = @seminar.start_on.to_s(:rfc2445) unless @seminar.start_on.blank?
        cal_event.end = @seminar.end_on.to_s(:rfc2445) unless @seminar.end_on.blank?
        cal_event.location = @seminar.location.building.name + ", " + @seminar.location.name unless @seminar.location.blank?
        summary = []
        summary << @seminar.title
        summary << @seminar.speakers.map{|s| s.name+' ('+s.affiliation+')'}
        cal_event.summary = summary.join(' | ')
        cal_event.url = seminar_url(@seminar)
        description = []
        description << @seminar.description unless @seminar.description.blank?
        description << "Hosted by: "+@seminar.hosts.map(&:name).join(', ')+'.'
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
    @seminar.hosts.build
    @seminar.speakers.build

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @seminar }
    end
  end

  # GET /seminars/1/edit
  def edit
    @seminar = Seminar.find(params[:id])
  end

  # POST /seminars
  # POST /seminars.xml
  def create
    @seminar = Seminar.new(params[:seminar])
    flash[:warning] = @seminar.errors.inspect
    respond_to do |format|
      if @seminar.save
        flash[:notice] = 'Seminar was successfully created.'
        format.html { redirect_to(@seminar) }
        format.xml  { render :xml => @seminar, :status => :created, :location => @seminar }
      else
        flash.now[:error] = 'Something went wrong.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @seminar.errors, :status => :unprocessable_entity }
      end
    end
    rescue Exception => e
      unless @seminar.nil?
        @seminar.errors.add(e, '')
        respond_to do |format|
          format.html { render 'new' }
        end
      else
        flash[:warning] = e
        respond_to do |format|
          format.html { redirect_back_or_default(seminars_path) }
        end       
      end
  end

  # PUT /seminars/1
  # PUT /seminars/1.xml
  def update
    @seminar = Seminar.find(params[:id])

    respond_to do |format|
      if @seminar.update_attributes(params[:seminar])
        flash[:notice] = 'Seminar was successfully updated.'
        format.html { redirect_to(@seminar) }
        format.xml  { head :ok }
      else
        flash.now[:error] = 'Something went wrong.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @seminar.errors, :status => :unprocessable_entity }
      end
    end
    rescue Exception => e
      @seminar.errors.add(e, '')
      respond_to do |format|
        format.html { render 'edit' }
      end
  end

  # DELETE /seminars/1
  # DELETE /seminars/1.xml
  def destroy
    @seminar = Seminar.find(params[:id])
    @seminar.destroy

    respond_to do |format|
      flash[:notice] = 'Seminar was successfully deleted.'
      format.html { redirect_to(seminars_url) }
      format.xml  { head :ok }
    end
  end
  
  def insert_person_in_form
    @seminar = params[:id] == 'new' ? Seminar.new : Seminar.find(params[:id])
    @person = params[:person] == 'host' ? @seminar.hosts.build : @seminar.speakers.build
    respond_to do |format|
      format.js
    end
  end
  
  protected
  
  def set_variables
    @buildings = Building.find :all
    @categories = Category.find(:all)
  end
end
