class LocationsController < ApplicationController
  
  before_filter :set_variables, :only => [:index, :show, :new, :create, :edit, :update]
  load_and_authorize_resource
  respond_to :html, :js, :xml
  
  def index
    @locations = Location.find(:all)
    @new_location = Location.new
    
    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @locations }
    end
  end
  
  def show
    @seminars = @location.seminars.paginate(:page => params[:page])
    @new_location = Location.new

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @location }
    end
  end
  
  def new
    respond_with @location do |format|
      format.js{
        @origin = params[:origin]
        render 'layouts/new', :content_type => 'text/javascript', :layout => false
      }
    end
  end
  
  def edit
    respond_with @location do |format|
      format.js { render 'layouts/edit', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  def create
    if @location.save
      flash[:notice] = 'Location was successfully created'      
      respond_with @location do |format|
        format.js{
          @origin = params[:origin]
          render (@origin.nil? ? 'layouts/insert_in_table' : 'create'), :content_type => 'text/javascript', :layout => false
        }
      end
    else
      flash[:alert] = 'Location not created'      
      respond_with @location do |format|
        format.js{
          @origin = params[:origin]
          render (@origin.nil? ? 'layouts/insert_in_table' : 'layouts/new'), :content_type => 'text/javascript', :layout => false
        }
      end
    end
  end
  
  def update
    if @location.update_attributes(params[:location])
      flash[:notice] = 'Location was successfully updated.'
    else
      flash[:alert] = 'Something went wrong.'
    end
    respond_with @location do |format|
      format.js {  render 'layouts/update', :content_type => 'text/javascript', :layout => false  }
    end
  end
  
  def destroy
    if @location.destroy
      respond_to do |format|
        flash[:notice] = 'Location was successfully deleted.'
        format.html { redirect_to(locations_url) }
        format.xml  { head :ok }
        format.js { render 'layouts/remove_from_table', :content_type => 'text/javascript', :layout => false  }
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
    @buildings = Building.all
  end
end
