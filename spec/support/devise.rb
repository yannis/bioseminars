RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller


  def sign_in_user(user=nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_out :user
    @user = user.presence || create(:user)
    sign_in @user
  end

  def sign_in_admin_user(user=nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_out :user
    @admin = user.presence || create(:user, admin: true)
    sign_in @admin
  end

end
