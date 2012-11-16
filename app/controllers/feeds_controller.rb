class FeedsController < ApplicationController

  def index
    @categories = Category.all
    cat = []
    if params[:categories].blank?
      if cookies[:seminars_to_show].nil? or eval(cookies[:seminars_to_show]).blank?
        cat += @categories.map{|i| i.id.to_s}
      else
        cat += @categories.map{|i| i.id.to_s} & eval(cookies[:seminars_to_show])
      end
    else
      cat += @categories.map{|i| i.id.to_s} & params[:categories]
    end
    selected_cat = cat
    if params[:internal].blank?
      cat << 'internal' unless cookies[:seminars_to_show].nil? or eval(cookies[:seminars_to_show]).blank? or !eval(cookies[:seminars_to_show]).include?('internal')
    else
      cat << 'internal' if params[:internal] == 'internal'
    end
    cookies[:seminars_to_show] = {:value => cat.to_json, :expires => 2.years.from_now }
    @internal = cat.include?('internal')
    @rss_feed = seminars_url(:format => 'rss', :categories => selected_cat.join(' '), :internal => @internal.to_s)
    @ical_feed = seminars_url(:protocol => 'webcal://', :format => 'ics', :categories => selected_cat.join(' '), :internal => @internal.to_s)
    @ics_feed = seminars_url(:format => 'ics', :categories => selected_cat.join(' '), :internal => @internal.to_s)
    @json_feed = seminars_url(:format => 'json', :categories => selected_cat.join(' '), :internal => @internal.to_s)
    @xml_feed = seminars_url(:format => 'xml', :categories => selected_cat.join(' '), :internal => @internal.to_s)
    @json_feed = seminars_url(:format => 'json', :categories => selected_cat.join(' '), :internal => @internal.to_s)
    @iframe = calendar_seminars_url(:format => 'iframe', :categories => selected_cat.join(' '), :internal => @internal.to_s)
  end

  # def create
  #   @categories = Category.all
  #   cat = []
  #   if params[:categories].blank?
  #     if cookies[:seminars_to_show].nil? or eval(cookies[:seminars_to_show]).blank?
  #       cat += @categories.map{|i| i.id.to_s}
  #     else
  #       cat += @categories.map{|i| i.id.to_s} & eval(cookies[:seminars_to_show])
  #     end
  #   else
  #     cat += @categories.map{|i| i.id.to_s} & params[:categories].match(/\d+/).to_a
  #   end
  #   selected_cat = cat
  #   if params[:internal].blank?
  #     cat << 'internal' unless cookies[:seminars_to_show].nil? or eval(cookies[:seminars_to_show]).blank? or !eval(cookies[:seminars_to_show]).include?('internal')
  #   else
  #     cat << 'internal' if params[:internal] == 'true'
  #   end
  #   cookies[:seminars_to_show] = cat.to_json
  #   @internal = cat.include?('internal')
  #   @rss_feed = seminars_url(:format => 'rss', :categories => selected_cat.join(' '), :internal => @internal.to_s)
  #   @ical_feed = seminars_url(:protocol => 'webcal://', :format => 'ics', :categories => selected_cat.join(' '), :internal => @internal.to_s)
  #   @ics_feed = seminars_url(:format => 'ics', :categories => selected_cat.join(' '), :internal => @internal.to_s)
  #   @xml_feed = seminars_url(:format => 'xml', :categories => selected_cat.join(' '), :internal => @internal.to_s)
  #   @iframe = calendar_seminars_url(:format => 'iframe', :categories => selected_cat.join(' '), :internal => @internal.to_s)
  #   respond_to do |format|
  #     format.html{ render :index}
  #   end
  # end
end
