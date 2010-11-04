require 'test_helper'
require 'webrat'

class OpenSeminarFormFromCalendarTest < ActionDispatch::IntegrationTest
  
  include Webrat::Methods 
  include Webrat::Matchers
  
  visit "/users/sign_in"
  assert_response :success 
  # fill_in :user_email, :with => users(:basic).email
  # fill_in :password, :with => "monkey"
  # click_button :user_submit
  # assert_equal(users(:basic).id, session[:user_id])
  
end
