require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuf


feature 'about', js: true do
  scenario "An API doc link is in the footer" do
    visit "/"
    within "nav.navbar" do
      expect(page).to have_selector "a", text: "About"
      click_link "About"
      expect(current_url).to match /\/#\/about/
      expect(page).to have_title "About bioSeminars"
    end
  end
end
