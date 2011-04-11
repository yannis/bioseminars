class HostsController < ApplicationController
  
  load_and_authorize_resource
  respond_to :html, :js, :xml
  
  def index
    @host = Host.new
  end
  
  def show
    @seminars = @host.seminars.paginate(:page => params[:page])
    @new_host = Host.new
  end
  
  def new
    @origin = params[:origin]
    respond_with @host do |format|
      format.js { render 'layouts/new', :content_type => 'text/javascript', :layout => false }
    end
  end

  def edit
    respond_with @host do |format|
      format.js { render 'layouts/edit', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  def create
    # @host = Host.new(params[:host])
    if @host.save
      flash[:notice] = 'Host was successfully created'
    else
      flash[:alert] = 'Host not created'
    end
    respond_with @host do |format|
      format.js{
        @origin = params[:origin]
        if @origin.nil?
          render 'layouts/insert_in_table', :content_type => 'text/javascript', :layout => false
        else
          render 'create', :content_type => 'text/javascript', :layout => false
        end
      }
    end
  end
  
  def update
    if @host.update_attributes(params[:host])
      flash[:notice] = 'Host was successfully updated'
    else
      flash[:alert] = 'Host not updated'
    end
    respond_with @host do |format|
      format.js{ render 'layouts/update', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  def destroy
    if @host.destroy
      flash[:notice] = 'Host was successfully deleted'
    else
      flash[:alert] = 'Unable to destroy host'
    end
    respond_with @host do |format|
      format.js { render 'layouts/remove_from_table', :content_type => 'text/javascript', :layout => false }
    end
  end
end
