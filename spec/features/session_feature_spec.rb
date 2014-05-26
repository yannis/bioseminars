require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'session', js: true do

  let(:admin) {create :user, name: "admin_user", email: "admin@bioseminars.com", admin: true}
  let!(:user) {create :user, name: "basic_user", email: "basic@bioseminars.com", admin: false}

  before {
    embersignout
    sleep 0.3
  }

  scenario "sign in with valid credentials" do
    visit "/#/login"
    expect(page).to have_text "Sign in"
    fill_in "identification", with: "admin@bioseminars.com"
    fill_in "password", with: admin.password
    click_button "Sign in"
    sleep 0.3
    within(".notifications") do
      expect(page).to have_text "Successfully signed in"
    end
    expect(page).to have_text "admin_user"
  end

  scenario "sign in with invalid credentials" do
    visit "/#/login"
    expect(page).to have_text "Sign in"
    fill_in "identification", with: "admin@bioseminars.com"
    fill_in "password", with: "invalid_password"
    click_button "Sign in"
    within(".notifications") do
      expect(page).to have_text "Invalid email or password"
    end
    expect(page).to have_text "Sign in"
  end

  scenario "cancel sign in" do
    visit "/#/login"
    fill_in "identification", with: "admin@bioseminars.com"
    fill_in "password", with: "invalid_password"
    click_link "Cancel"
    expect(page).to have_selector("#calendar", count: 1)
  end

  scenario "test signin helper" do
    embersignin user
    sleep 0.3
    visit "/"
    expect(page).to have_text "basic_user"
  end
end
