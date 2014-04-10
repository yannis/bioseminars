require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuf


feature 'seminars', js: true do
  scenario "An API doc link is in the footer" do
    visit "/"
    within "#footer" do
      expect(page).to have_selector "a", text: "feeds API"
      click_link "feeds API"
      expect(current_url).to match /\/#\/feeds\/documentation/
      expect(page).to have_title "API documentation"
    end
  end
end
