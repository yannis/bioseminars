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
  
  def controllers_and_actions
    navigation = {}
    # navigation[:orders] = {:main_menu => {:text => "orders", :path => orders_path}, :sub_menus => [{:text => "new", :path => new_order_path}], :highlight_in_controller => ["orders"]}
    # navigation[:orders][:sub_menus] << {:text => "categories", :path => categories_path, :sub_menus => [{:text => "new", :path => new_category_path}]}
    navigation[:seminars] = {:main_menu => {:text => "seminars", :path => seminars_path}, :sub_menus => [{:text => "new", :path => new_seminar_path}], :highlight_in_controller => ["seminars"]}
    navigation[:locations] = {:main_menu => {:text => "locations", :path => locations_path}, :sub_menus => [{:text => "new", :path => new_location_path}], :highlight_in_controller => ["locations"]}
    navigation[:locations][:sub_menus] << {:text => "buildings", :path => buildings_path, :sub_menus => [{:text => "new", :path => new_building_path}]}
    navigation[:categories] = {:main_menu => {:text => "categories", :path => categories_path}, :sub_menus => [{:text => "new", :path => new_category_path}], :highlight_in_controller => ["categories"]}
    navigation[:users] = {:main_menu => {:text => "users", :path => users_path}, :sub_menus => [{:text => "new", :path => new_user_path}], :highlight_in_controller => ["users"]}
    # navigation[:products] = {:main_menu => {:text => "products", :path => products_path}, :sub_menus => [{:text => "new", :path => new_product_path}], :highlight_in_controller => ["products"]}
    # navigation[:products][:sub_menus] << {:text => "brands", :path => brands_path, :sub_menus => [{:text => "new", :path => new_brand_path}]}
    # navigation[:alleles][:sub_menus] << {:text => "PCRs", :path => pcrs_path, :sub_menus => [{:text => "new", :path => new_pcr_path}]}
    # if current_user.labadmin?
    #   navigation[:laboratory] = {:main_menu => {:text => "laboratory", :path => laboratory_path(current_user.laboratory.id)}, :sub_menus => [], :highlight_in_controller => ["laboratory"]}
    #   navigation[:laboratory][:sub_menus] << {:text => "users", :path => laboratory_users_path(current_user.laboratory.id), :sub_menus => [{:text => "new", :path => new_laboratory_user_path(current_user.laboratory.id)}]}
    # end
    # 
    # if current_user.admin?
    #   navigation[:laboratories] = {:main_menu => {:text => "laboratories", :path => laboratories_path}, :sub_menus => [{:text => "new", :path => new_laboratory_path}], :highlight_in_controller => ["laboratories_path"]}
    # end
    return navigation
  end
  
  def admin?
    current_user.role.to_s == 'admin'
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
end
