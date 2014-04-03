class Api::V2::BaseController < ActionController::Base
  # include ActionController::Rendering        # enables rendering
  # include ActionController::ImplicitRender
  # include ActionController::MimeResponds     # enables serving different content types like :xml or :json
  # include AbstractController::Callbacks      # callbacks for your authentication logic
  # include ActiveModel::Serializable

  # append_view_path "#{Rails.root}/app/views" # you have to specify your views location as well


  def ember_url(object)
    "#{request.host}/#/#{object.class.to_s.tableize}/#{object.id}"
  end

end
