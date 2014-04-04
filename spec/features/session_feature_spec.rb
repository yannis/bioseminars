require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'session', js: true do

  let(:admin) {create :user, name: "admin_user", email: "admin@bioseminars.com", admin: true}
  let(:user) {create :user, name: "basic_user", email: "basic@bioseminars.com", admin: false}

  # before {visit "/#/sessions/destroy"}

  scenario "sign in with valid credentials" do
    visit "/#/sessions/new"
    expect(page).to have_text "Sign in"
    fill_in "email", with: "admin@bioseminars.com"
    fill_in "password", with: admin.password
    click_button "Sign in"
    within(".notifications") do
      expect(page).to have_text "Successfully signed in"
    end
    expect(page).to have_text "admin_user"
  end

  scenario "sign in with invalid credentials" do
    visit "/#/sessions/new"
    expect(page).to have_text "Sign in"
    fill_in "email", with: "admin@bioseminars.com"
    fill_in "password", with: "invalid_password"
    click_button "Sign in"
    within(".notifications") do
      expect(page).to have_text "invalid email or password"
    end
    expect(page).to have_text "Sign in"
  end

  scenario "cancel sign in" do
    visit "/#/sessions/new"
    fill_in "email", with: "admin@bioseminars.com"
    fill_in "password", with: "invalid_password"
    click_link "Cancel"
    expect(page).to have_selector("#calendar", count: 1)
  end

  scenario "test signin helper" do
    embersignin user
    visit "/"
    expect(page).to have_text "basic_user"
  end
end
