class BuildingsController < ApplicationController
  
  load_and_authorize_resource
  respond_to :html, :js, :xml
  
  def index
    @new_building = Building.new
    respond_with @buildings
  end
  
  def show
    @seminars = @building.seminars.paginate(:page => params[:page])
    @new_building = Building.new

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @building }
    end
  end
  
  def new
    @origin = params[:origin]

    respond_with @building do |format|
      format.js { render 'layouts/new', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  def edit
    respond_with @building do |format|
      format.js {  render 'layouts/edit', :content_type => 'text/javascript', :layout => false  }
    end
  end
  
  def create
    if @building.save
      flash[:notice] = 'Building was successfully created'      
      respond_with @building do |format|
        format.js{
          @origin = params[:origin]
          render (@origin.nil? ? 'layouts/insert_in_table' : 'create'), :content_type => 'text/javascript', :layout => false
        }
      end
    else
      flash[:alert] = 'Building not created'      
      respond_with @building do |format|
        format.js{
          @origin = params[:origin]
          render (@origin.nil? ? 'layouts/insert_in_table' : 'layouts/new'), :content_type => 'text/javascript', :layout => false
        }
      end
    end
  end
  
  #   def create
  #   if @building.save
  #     flash[:notice] = 'Building was successfully created.'
  #   else
  #     flash[:alert] = 'Building not created'
  #   end
  #   respond_with @building do |format|
  #     format.js{
  #       @origin = params[:origin]
  #       render (@origin.nil? ? 'layouts/insert_in_table' : 'create'), :content_type => 'text/javascript', :template => false
  #     }
  #   end
  # end
  
  def update
    if @building.update_attributes(params[:building])
      flash[:notice] = 'Building was successfully updated'
    else
      flash[:alert] = 'Building not updated'
    end
    respond_with @building do |format|
      format.js{ render 'layouts/update', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  def destroy
    if @building.destroy
      flash[:notice] = 'Building was successfully deleted'
    else
      flash[:alert] = 'Unable to destroy building'
    end
    respond_with @building do |format|
      format.js { render 'layouts/remove_from_table', :content_type => 'text/javascript', :layout => false }
    end
  end
end
