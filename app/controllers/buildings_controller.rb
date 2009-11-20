class BuildingsController < ApplicationController
  
  skip_before_filter :login_required, :only => ['index', 'show']
  before_filter :admin_required, :only => ['new', 'create', 'edit', 'update', 'destroy']
    
  # GET /buildings
  # GET /buildings.xml
  def index
    @buildings = Building.find(:all)
    @new_building = Building.new

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @buildings }
    end
  end

  # GET /buildings/1
  # GET /buildings/1.xml
  def show
    @building = Building.find(params[:id])
    @seminars = @building.seminars.paginate(:page => params[:page])
    @new_building = Building.new

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @building }
    end
  end

  # GET /buildings/new
  # GET /buildings/new.xml
  def new
    @building = Building.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @building }
      format.js{
        @origin = params[:origin]
        render :template => 'layouts/new.rjs'
      }
    end
  end

  # GET /buildings/1/edit
  def edit
    @building = Building.find(params[:id])

    respond_to do |format|
      format.html # new.html.haml
      format.js {
        render 'layouts/edit'
      }
    end
  end

  # POST /buildings
  # POST /buildings.xml
  def create
    @building = Building.new(params[:building])

    respond_to do |format|
      if @building.save
        flash[:notice] = 'Building was successfully created.'
        format.html { redirect_to @building }
        format.xml  { render :xml => @building, :status => :created, :location => @building }
        format.js{
          @origin = params[:origin]
          if @origin.nil?
            render 'layouts/insert_in_table'
          else
            render 'create'
          end
        }
      else
        # flash[:warning] = 'Something went wrong.'
        flash[:warning] = 'Building not created.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
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

  # PUT /buildings/1
  # PUT /buildings/1.xml
  def update
    @building = Building.find(params[:id])

    respond_to do |format|
      if @building.update_attributes(params[:building])
        flash[:notice] = 'Building was successfully updated.'
        format.html { redirect_to(@building) }
        format.xml  { head :ok }
        format.js {
          render 'layouts/update'
        }
      else
        flash[:warning] = 'Something went wrong.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @building.errors, :status => :unprocessable_entity }
        format.js {
          render 'layouts/update'
        }
      end
    end
  end

  # DELETE /buildings/1
  # DELETE /buildings/1.xml
  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    respond_to do |format|
      flash[:notice] = 'Building was successfully deleted.'
      format.html { redirect_to(buildings_url) }
      format.xml  { head :ok }
      format.js { render 'layouts/remove_from_table' }
    end
  end
end
