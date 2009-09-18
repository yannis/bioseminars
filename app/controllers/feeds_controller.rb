class FeedsController < ApplicationController
  
  skip_before_filter :login_required
  
  def new
    
  end
  
  def create
    @categories = Category.find(params[:category_ids])
    @rss_feed = seminars_url(:format => 'rss', :categories => @categories.map{|c| c.id}.join(' '))
    @ics_feed = seminars_url(:format => 'ics', :categories => @categories.map{|c| c.id}.join(' '))
    @xml_feed = seminars_url(:format => 'xml', :categories => @categories.map{|c| c.id}.join(' '))
    @iframe = seminars_url(:format => 'iframe', :categories => @categories.map{|c| c.id}.join(' '))
  end
end
