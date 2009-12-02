# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files)}
  end
  
  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files)}
  end
  
  def onload(content)
    content_for(:onload){ content }
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
  
  def controllers_and_actions
    navigation = {}
    navigation[:seminars] = {:main_menu => {:text => "calendar", :path => calendar_seminars_path}, :sub_menus => [{:text => "as list", :path => seminars_path}], :highlight_in_controller => ["seminars"]}
    navigation[:categories] = {:main_menu => {:text => "categories", :path => categories_path}, :sub_menus => [], :highlight_in_controller => ["categories"]}
    navigation[:locations] = {:main_menu => {:text => "locations", :path => locations_path}, :sub_menus => [], :highlight_in_controller => ["locations", 'buildings']}
    navigation[:locations][:sub_menus] << {:text => "buildings", :path => buildings_path, :sub_menus => []} 
    if basic_or_admin?
      navigation[:seminars][:sub_menus] << {:text => "new", :path => new_seminar_path} 
    end
    if admin?
      navigation[:users] = {:main_menu => {:text => "users", :path => users_path}, :sub_menus => [], :highlight_in_controller => ["users"]}
    end
    return navigation
  end
  
  def basic?
    current_user and current_user.role.to_s == 'basic'
  end
  
  def admin?
    current_user and current_user.role.to_s == 'admin'
  end
  
  def basic_or_admin?
    current_user and (current_user.role.to_s == 'admin' || current_user.role.to_s == 'basic')
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
    link_to 'Edit', eval("edit_#{object.class.to_s.underscore}_path(object)")
  end
  
  def destroy_link(object)
    link_to 'Destroy', eval("#{object.class.to_s.underscore}_path(object)"), :confirm => "Are you sure?", :method => :delete, :title => "Destroy #{object.class.to_s.underscore} #{'“'+object.name+'”' if object.respond_to?(:name)}"
  end
  
  def destroy_remote_link(object)
    link_to_remote 'Destroy', {:url => eval("#{object.class.to_s.underscore}_path(object)"), :confirm => "Are you sure?", :method => :delete}, {:title => "Destroy #{object.class.to_s.underscore} #{'“'+object.name+'”' if object.respond_to?(:name)}"}
  end
  
  def flash_in_rjs(notice=nil, warning=nil)
    flash = []
    flash << "if ($('flash_notice')) {$('flash_notice').remove()}"
    flash << "if ($('flash_warning')) {$('flash_warning').remove()}"
    unless notice.nil?
      flash << "var g = new k.Growler(); g.info('#{notice}', {life: 5});"
    end
    unless warning.nil?
      flash << "var g = new k.Growler(); g.error('#{warning}', {life: 5});"
    end
    return flash.join
  end
  
  def my_link_to_remote(object_to_create, object_of_origin, object_to_create_index=nil, object_of_origin_index=nil, text='(+)', title=nil)
    loader_id = "loader_new_#{object_to_create}#{object_to_create_index.nil? ? '' : '_'+object_to_create_index.to_s}#{object_of_origin}#{object_of_origin_index.nil? ? '' : ('_'+object_of_origin_index.to_s)}"
    link_id = "create_#{object_to_create}#{object_to_create_index.nil? ? '' : '_'+object_to_create_index.to_s}_#{object_of_origin}#{object_of_origin_index.nil? ? '' : ('_'+object_of_origin_index.to_s)}"
    loader = image_tag('ajax-loader.gif', :style => 'display: none', :id => loader_id)
    href = object_to_create.to_s == 'mouse' ? eval("new2_mice_path(:mouse => {:name => ''}, :number => {:males => '1', :females => '0'})") : eval("new_#{object_to_create}_path") 
    options = {:url => href, :before => "Element.hide('#{link_id}'); Element.show('#{loader_id}')", :complete => "Element.hide('#{loader_id}'); Element.show('#{link_id}')" , :method => :get}
    opt = ["origin=#{object_of_origin}"]
    opt << "index=#{object_to_create_index}" unless object_to_create_index.nil?
    opt << "origin_index=#{object_of_origin_index}" unless object_of_origin_index.nil?
    options[:with] = "'"+opt.join('&')+"'"
    link = link_to_remote(
      text, 
      options,
      {:id => "#{link_id}", :href => href, :title => title, :class => 'add_abject'} 
      )
    link = link+loader
  end
  
  def show_category?(category)
    if params[:format] == 'iframe' and (params[:categories].nil? or (!params[:categories].nil? and params[:categories].include?(category.id.to_s)))
      return true
    elsif cookies[:__CJ_seminars_to_show].blank?
      cookies[:__CJ_seminars_to_show] = Category.all.map{|c| c.id.to_s}.to_json
      return true
    else
      return eval(cookies[:__CJ_seminars_to_show]).include?(category.id.to_s)
    end
  end
  
  def show_internal_seminars?
    if cookies[:__CJ_show_internal_seminars].blank?
      cookies[:__CJ_show_internal_seminars] = ['false'].to_json
      return false
    else
      return eval(cookies[:__CJ_show_internal_seminars]).include?('true')
    end
  end
  
  def replace_by_new_form(object)
    update_page do |page|
      page.replace_html('new_or_edit_form', :partial => 'layouts/new_box', :locals => {:object => object.class.new})
    end
  end
  
  def test_for(*params)
    return 'prout'
  end
end
