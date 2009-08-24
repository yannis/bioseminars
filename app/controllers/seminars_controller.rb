class SeminarsController < ApplicationController
  
  before_filter :set_variables
  # GET /seminars
  # GET /seminars.xml
  def index
    @seminars = Seminar.find(:all)
    @days_with_seminars = @seminars.map{|s| s.start_on.to_date}

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @seminars }
    end
  end

  # GET /seminars/1
  # GET /seminars/1.xml
  def show
    @seminar = Seminar.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @seminar }
    end
  end

  # GET /seminars/new
  # GET /seminars/new.xml
  def new
    @seminar = Seminar.new
    @seminar.hosts.build
    @seminar.speakers.build
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
  
  protected
  
  def set_variables
    @buildings = Building.find :all
    @categories = Category.find(:all)
  end
end
