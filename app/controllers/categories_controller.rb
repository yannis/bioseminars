class CategoriesController < ApplicationController
  
  before_filter :authenticate_user!, :only => ['new', 'create', 'edit', 'update', 'destroy']
  load_and_authorize_resource
  respond_to :html, :js, :xml
  
  def index
    @category = Category.new

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @seminars = @category.seminars.paginate(:page => params[:page])
    @new_category = Category.new

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @category }
    end
  end
  
  def new
    @origin = params[:origin]

    respond_with @category do |format|
      format.js { render 'layouts/new', :content_type => 'text/javascript', :layout => false }
    end
  end

  def edit
    # @categories = Category.find(:all)

    respond_with @category do |format|
      format.js { render 'layouts/edit', :content_type => 'text/javascript', :layout => false }
    end
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = 'Category was successfully created'
    else
      flash[:alert] = 'Category not created'
    end
    respond_to do |format|
      format.html { redirect_to categories_path }
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

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated'
    else
      flash[:alert] = 'Category not updated'
    end
    respond_with @category do |format|
      format.js{ render 'layouts/update', :content_type => 'text/javascript', :layout => false }
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:notice] = 'Category was successfully deleted'
    else
      flash[:alert] = 'Unable to destroy category'
    end
    respond_with @category do |format|
      format.js { render 'layouts/remove_from_table', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  def reorder
    ids = eval(params[:ids_in_order]).map{|p| p.delete('category_')}
    flash[:notice] = ids.inspect
    Category.transaction do
      begin
        @categories = Category.all
        @categories.each do |category|
          category.update_attribute(:position, ids.index(category.id.to_s) + 1)
        end
        flash[:notice] = "Categories reordered."
      rescue
        flash[:alert] = "Categories not reordered."
      end
    end
    respond_to do |format|
      format.js {render 'layouts/reorder', :content_type => 'text/javascript', :layout => false }
    end
  end
  
  # def sort
  #   i = 1
  #   if params[:tbody_in_category_table].each{|id|
  #     document = Category.find(id)
  #     document.update_attributes(:position => (i))
  #     i += 1
  #   }
  #     flash[:notice] = "Reordering successful"
  #   else
  #     flash[:notice] = "Reordering failed"
  #   end
  #   respond_to do |format|
  #     format.js
  #     format.html { redirect_to :nothing => true }
  #   end
  # end
end
