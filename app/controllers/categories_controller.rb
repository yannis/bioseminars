class CategoriesController < ApplicationController
  
  skip_before_filter :login_required, :only => ['index', 'show']
  before_filter :admin_required, :only => ['new', 'edit', 'create', 'update', 'destroy', 'sort']
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.find(:all)
    @category = Category.new

    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    @seminars = @category.seminars.paginate(:page => params[:page])
    @new_category = Category.new

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml  { render :xml => @category }
      format.js{
        @origin = params[:origin]
        render :template => 'layouts/new.rjs'
      }
    end
  end

  # GET /categories/1/edit
  def edit
    @categories = Category.find(:all)
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @categories }
      format.js {
        render 'layouts/edit'
      }
    end
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        format.html { redirect_to(@category) }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
        format.js{
          @origin = params[:origin]
          if @origin.nil?
            render 'layouts/insert_in_table'
          else
            render 'create'
          end
        }
      else
        flash[:warning] = 'Category not created.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
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

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(@category) }
        format.xml  { head :ok }
        format.js {
          render 'layouts/update'
        }
      else
        flash[:warning] = 'Something went wrong.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
        format.js{
          render 'layouts/update'
        }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      flash[:notice] = 'Category was successfully deleted.'
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
      format.js { render 'layouts/remove_from_table' }
    end
  end
  
  def sort
    i = 1
    if params[:tbody_in_category_table].each{|id|
      document = Category.find(id)
      document.update_attributes(:position => (i))
      i += 1
    }
      flash[:notice] = "Reordering successful"
    else
      flash[:notice] = "Reordering failed"
    end
    respond_to do |format|
      format.js
      format.html { redirect_to :nothing => true }
    end
  end
end
