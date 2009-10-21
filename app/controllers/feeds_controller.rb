class FeedsController < ApplicationController
  
  skip_before_filter :login_required
  
  def index
    @categories = Category.all
    if params[:category_ids].blank?
      if cookies[:__CJ_seminars_to_show].nil? or eval(cookies[:__CJ_seminars_to_show]).blank?
        cat_to_find = :all
      else
        cat_to_find = eval(cookies[:__CJ_seminars_to_show])
      end
    else
      cat_to_find = params[:category_ids].reject{|c| c == 'internal'}
    end
    if params[:internal].blank?
      if cookies[:__CJ_show_internal_seminars].nil? or eval(cookies[:__CJ_show_internal_seminars]).blank?
        @internal = false
      else
        @internal = eval(cookies[:__CJ_show_internal_seminars]) == 'true'
      end
    else
      @internal = params[:internal] == 'true'
    end
    @selected_categories = Category.find(cat_to_find)
    @rss_feed = seminars_url(:format => 'rss', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    @ics_feed = seminars_url(:protocol => 'webcal://', :format => 'ics', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    @xml_feed = seminars_url(:format => 'xml', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    @iframe = calendar_seminars_url(:format => 'iframe', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
  end
  
  def create
    @categories = Category.all
    if params[:category_ids].blank?
      if cookies[:__CJ_seminars_to_show].nil? or eval(cookies[:__CJ_seminars_to_show]).blank?
        cat_to_find = :all
      else
        cat_to_find = eval(cookies[:__CJ_seminars_to_show])
      end
      @internal = cookies[:__CJ_seminars_to_show].nil? ? false : (eval(cookies[:__CJ_seminars_to_show]) == ['true'])
    else
      @internal = params[:internal]
      cat_to_find = params[:category_ids].reject{|c| c == 'internal'}
    end
    @selected_categories = Category.find(cat_to_find)
    @rss_feed = seminars_url(:format => 'rss', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    @ics_feed = seminars_url(:protocol => 'webcal://', :format => 'ics', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    @xml_feed = seminars_url(:format => 'xml', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    @iframe = calendar_seminars_url(:format => 'iframe', :categories => @selected_categories.map{|c| c.id}.join(' '), :internal => @internal)
    respond_to do |format|
      format.html{ render :index}
    end        
  end
end
