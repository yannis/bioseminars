# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def javascript(*files)
    content_for(:javascript) { javascript_include_tag(*files)}
  end
  
  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files)}
  end
  
  def document_ready(content)
    content_for(:document_ready){ 
      javascript_tag do
        content
      end  
    }
  end
  
  def submit_or_cancel_form(f)
    "#{f.submit} or #{link_to_function( 'cancel', (@origin.nil? ? (f.object.new_record? ? "$(this).parents('form').clearForm()" : replace_by_new_form(f.object)) : "remove_div_and_overlay($(this).parents('.ajax_div').attr('id'))"))}".html_safe
  end
  
  def update_button
    "<span class='button inline_in_form'>"+submit_tag('Update', :class => "confirm button") + ' or ' + link_to('cancel', back_path)+"</span>"
  end
  
  def create_button(text=nil)
    "<span class='button inline_in_form'>"+submit_tag(text || 'Create', :class => "confirm button") + ' or ' + link_to('cancel', back_path)+"</span>"
  end

  def destroy_button
    "<span class='button inline_in_form'>"+submit_tag('Destroy', :class => "confirm button") + ' or ' + link_to('cancel', back_path)+"</span>"
  end
  
  def controller?(*controller)
    controller.map{|a| a.to_s }.include?(params[:controller].to_s)
  end
  
  def action?(*action)
    action.map{|a| a.to_s }.include?(params[:action].to_s)
  end
  
  def controllers_and_actions
    navigation = {}
    if controller?('seminars') && action?('calendar')
      navigation[:seminars] = {:main_menu => {:text => "seminar list", :path => seminars_path(:scope => 'future')}, :sub_menus => [{:text => "calendar", :path => calendar_seminars_path}], :highlight_in_controller => ["seminars"]}
    else
      navigation[:seminars] = {:main_menu => {:text => "calendar", :path => calendar_seminars_path}, :sub_menus => [{:text => "as list", :path => seminars_path(:scope => 'future')}], :highlight_in_controller => ["seminars"]}
    end
    navigation[:categories] = {:main_menu => {:text => "categories", :path => categories_path}, :sub_menus => [], :highlight_in_controller => ["categories"]}
    navigation[:locations] = {:main_menu => {:text => "locations", :path => locations_path}, :sub_menus => [], :highlight_in_controller => ["locations", 'buildings']}
    navigation[:locations][:sub_menus] << {:text => "buildings", :path => buildings_path, :sub_menus => []} 
    if user_signed_in?
      navigation[:seminars][:sub_menus] << {:text => "new", :path => new_seminar_path} 
    end
    if admin?
      navigation[:users] = {:main_menu => {:text => "users", :path => users_path}, :sub_menus => [], :highlight_in_controller => ["users"]}
    end
    return navigation
  end
  
  def basic?
    current_user.try(:admin) == false
  end
  
  def admin?
    current_user.try(:admin) == true
  end
  
  def basic_or_admin?
    user_signed_in?
  end
  
  def index?
    params[:action] == 'index'
  end
    
  def show?
    params[:action] == 'show'
  end
  
  def new_link(object_s, nested_in_object=nil)
    link_to 'New', eval("new#{'_'+nested_in_object.class.to_s.underscore unless nested_in_object.nil?}_#{object_s}_path#{'(nested_in_object)' unless nested_in_object.nil?}"),  :title => "Create a new #{object_s}"
  end
  
  def edit_link(object)
    link_to 'Edit', [:edit, object]
  end
  
  def destroy_link(object)
    link_to 'Destroy', object, :confirm => "Are you sure?", :method => :delete, :remote => !(controller?(object.class.to_s.pluralize.underscore) && action?('show') ), :title => "Destroy #{object.class.to_s.underscore} #{'“'+object.name+'”' if object.respond_to?(:name)}"
  end
  
  def destroy_remote_link(object)
    link_to 'Destroy', object, :confirm => "Are you sure?", :method => :delete, :remote => true, :title => "Destroy #{object.class.to_s.underscore} #{'“'+object.name+'”' if object.respond_to?(:name)}"
  end
  
  def flash_in_js
    "$.gritter.add({title: 'warning', class_name: 'warning',	text: '#{flash[:alert]}'});" unless flash[:alert].blank?
    "$.gritter.add({title: 'notice', class_name: 'notice',	text: '#{flash[:notice]}'});" unless flash[:notice].blank?
  end
  
  def my_link_to_remote(object_to_create, object_of_origin, object_to_create_index=nil, object_of_origin_index=nil, text='(+)', title=nil)
    link_id = ['create', object_to_create, object_to_create_index, object_of_origin, object_of_origin_index].compact.join('_')
    title = "Add an #{object_to_create.to_s}"
    url = url_for(:controller => object_to_create.to_s.pluralize, :action => 'new')
    options = {:method => :get, :remote => true}
    opt = []
    opt << "origin=#{object_of_origin}"
    opt << "index=#{object_to_create_index}" unless object_to_create_index.nil?
    opt << "origin_index=#{object_of_origin_index}" unless object_of_origin_index.nil?
    opt = opt.join('&')
    url = [url,opt].join('?')
    link = link_to(text, url, :method => :get, :remote => true, :id => "#{link_id}", :title => title, :class => 'add_object')
  end
  
  def show_category?(category)
    if params[:format] == 'iframe' and (params[:categories].nil? or (!params[:categories].nil? and params[:categories].include?(category.id.to_s)))
      return true
    elsif cookies[:seminars_to_show].blank?
      cookies[:seminars_to_show] = Category.all.map{|c| c.id.to_s}.to_json
      return true
    else
      return eval(cookies[:seminars_to_show]).include?(category.id.to_s)
    end
  end
  
  def show_internal_seminars?
    if cookies[:seminars_to_show].blank?
      cookies[:seminars_to_show] = Category.all.map{|c| c.id.to_s}.to_json
      return false
    else
      return eval(cookies[:seminars_to_show]).include?('internal')
    end
  end
  
  def replace_by_new_form(object)
    html =  render 'layouts/new_box', :object => object.class.new
    js = "$('#new_or_edit_form').html('#{escape_javascript(html).html_safe}');"
    js <<  %{
      $('#category_color').ColorPicker({
    	  color: '<%= object.color %>', 
    	  onShow: function (colpkr) {
    		  $(colpkr).fadeIn(500);
    		  return false;                                                          
    	  },                                                                       
    	  onHide: function (colpkr) {                                              
    		  $(colpkr).fadeOut(500);                                                
    		  return false;                                                          
    	  },                                                                       
    	  onChange: function (hsb, hex, rgb) {                                     
    		  $('#category_color').css('background-color', '#' + hex);               
    		  $('#category_color').val(hex);                                         
    	  }                                                                        
      });
    } if object.class == Category
    js << "insert_loaders();"
  end
  
  def load_publications_for(seminars)
    js = ""
    for seminar in seminars
      js += "$.ajax({url: '#{load_publications_seminar_path(seminar)}'});"
    end
    return js
  end
  
  def test_for(*params)
    return 'prout'
  end
end
