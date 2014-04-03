require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'password', js: true do

  let!(:admin) {create :user, name: "yannis", email: "yannis@bioseminars.com", admin: true}

  # before {visit "/#/sessions/destroy"}

  scenario "get a reset password link" do
    token = "asimpleresetpasswordtoken"
    digested_token = Devise.token_generator.digest(admin.class, :reset_password_token, token)
    # p "admin reset_password_token 1: #{admin.reset_password_token}"
    expect(admin.reset_password_token).to be_nil
    visit "/#/sessions/new"
    click_link "Did you forget your password?"
    expect(page).to have_text "Reset your password"
    fill_in "email", with: admin.email
    click_button "Send me reset password instructions"
    within(".notifications") do
      expect(page).to have_text "You will receive an email with instructions about how to reset your password in a few minutes."
    end
    uri = URI.parse(current_url)
    expect(uri.fragment).to eq "/sessions/new"
    # p "admin reset_password_token 2: #{admin.reload.reset_password_token}"

    admin.update_attributes! reset_password_token: digested_token
    # p "admin reset_password_token 3: #{admin.reload.reset_password_token}"


    visit "http://bioseminars.dev/#/users/new_password/#{token}"
    expect(page).to have_text "Change your password"
    fill_in "password", with: "qwertzuiop"
    fill_in "password_confirmation", with: "qwertzuiop"
    click_button "Update your password"
    # within(".notifications") do
    #   expect(page).to have_text "Password updated."
    # end
  end
    # "#{uri.path}?#{uri.query}".should == "jhjkf"

    # p "2: #{admin.reload.reset_password_token}"
    # visit "/#/users/new_password/#{admin.reload.reset_password_token}"
    # expect(page).to have_text "Change your password"
    # sleep 1
    # fill_in "password", with: "123456"
    # fill_in "password_confirmation", with: "123456"
    # click_button "Update your password"
    # within(".notifications") do
    #   expect(page).to have_text "Your password was changed successfully."
    # end
    # expect(page).to have_text "Sign in"
end
