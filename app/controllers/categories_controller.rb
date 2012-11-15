class CategoriesController < ApplicationController

  load_and_authorize_resource
  respond_to :html

  def index
    @category = Category.new
    respond_with @categories do |format|
      format.xml  { render :xml => @categories }
    end
  end

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
    respond_with @category do |format|
      format.js { render 'layouts/edit', :content_type => 'text/javascript', :layout => false }
    end
  end

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

  def update
    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category successfully updated'
    else
      flash[:alert] = 'Category updated'
    end
    respond_with @category do |format|
      format.js{ render 'layouts/update', :content_type => 'text/javascript', :layout => false }
    end
  end

  def destroy
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
    # @categories = Category.accessible_by(current_ability)
    # authorize! :reorder, @categories
    ids = eval(params[:ids_in_order]).map{|p| p.delete('category_')}
    Category.transaction do
      begin
        @categories.each do |category|
          category.update_attribute(:position, ids.index(category.id.to_s) + 1)
        end
        flash[:notice] = "Categories reordered."
      rescue
        flash[:warning] = "Categories not reordered."
      end
    end
    respond_with @categories do |format|
      format.js {render 'layouts/reorder', :content_type => 'text/javascript', :layout => false }
    end
    rescue Exception => e
      flash[:alert] = e.message
  end
end
