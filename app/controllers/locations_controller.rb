class LocationsController < ApplicationController
  
  skip_before_filter :login_required, :only => ['index', 'show']
  before_filter :set_variables, :only => [:index, :show, :new, :create, :edit, :update]
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.find(:all)
    @new_location = Location.new
    
    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    @seminars = @location.seminars.paginate(:page => params[:page])
    @new_location = Location.new

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @location }
      format.js{
        @origin = params[:origin]
        render :template => 'layouts/new.rjs'
      }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # new.html.haml
      format.js {
        render 'layouts/edit'
      }
    end
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(@location) }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
        format.js{
          @origin = params[:origin]
          if @origin.nil?
            render 'layouts/insert_in_table'
          else
            render 'create'
          end
        }
      else
        flash[:warning] = 'Something went wrong.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        format.js{
          @origin = params[:origin]
          if @origin.nil?
            render 'layouts/insert_in_table'
          else
            render :template => 'layouts/new.rjs'
          end
        }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@location) }
        format.xml  { head :ok }
        format.js {
          render 'layouts/update'
        }
      else
        flash[:warning] = 'Something went wrong.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
        format.js {
          render 'layouts/update'
        }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    if @location.no_more_seminars? and @location.destroy
      respond_to do |format|
        flash[:notice] = 'Location was successfully deleted.'
        format.html { redirect_to(locations_url) }
        format.xml  { head :ok }
        format.js { render 'layouts/remove_from_table' }
      end
    else
      respond_to do |format|
        flash[:notice] = 'Not deleted.'
        format.html { redirect_to(location_url(@location)) }
        format.xml  { head :ok }
        format.js { redirect_to(location_url(@location, :format => 'html')) }
      end
    end
  end

  protected

  def set_variables
    @buildings = Building.find(:all)
  end
end
