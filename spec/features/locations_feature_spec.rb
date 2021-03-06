require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'locations', js: true do

  let!(:location1) {create :location}
  let!(:location2) {create :location}
  let!(:location3) {create :location}
  let!(:location4) {create :location}
  let!(:location5) {create :location}
  let!(:building) {create :building}

  context "when not logged in" do
    before {
      embersignout
      visit "/#/locations"
    }

    scenario 'showing the list of locations' do
      expect(page).to have_title "All rooms"
      expect(page).to have_selector(".locations-locations")
      within(".locations-locations") do
        expect(page).to have_selector(".locations-location", count: 5)
        expect(page).to have_selector(".locations-location a", text: location1.name, count: 1)
      end
    end

    scenario 'Showing a location' do
      within(".locations-locations") do
        click_link location1.name
      end
      expect(current_url).to match /\/#\/locations\/#{location1.id}$/
      expect(page).to have_selector(".panel.location", count: 1)
      within(".panel.location") do
        expect(page).to have_text(location1.name, count: 1)
        expect(page).to_not have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.location")
      expect(current_url).to match /\/#\/locations$/
    end

    scenario "creating a location" do
      visit "/#/locations/new"
      it_does_not_authorize_and_redirect_to /\/#\/locations$/
    end

    scenario "editing a location" do
      visit "/#/locations/#{location1.id}/edit"
      it_does_not_authorize_and_redirect_to /\/#\/locations$/
    end
  end

  for role in ["member", "admin"]
    context "when signed in as #{role}" do
      let(:user) {create :user, admin: (role == "admin")}
      before {
        embersignin user
        visit "/#/locations"
      }

      scenario 'showing the list of locations'do
        expect(page).to have_title "All rooms"
        expect(page).to have_selector(".locations-locations")
        within(".locations-locations") do
          expect(page).to have_selector(".locations-location", count: 5)
          expect(page).to have_selector(".locations-location a", text: location1.name, count: 1)
        end
      end

      scenario 'Showing a location' do
        within(".locations-locations") do
          click_link location1.name
        end
        expect(current_url).to match /\/#\/locations\/#{location1.id}$/
        expect(page).to have_selector(".panel.location", count: 1)
        within(".panel.location") do
          expect(page).to have_text(location1.name, count: 1)
          expect(page).to have_selector("a", text: 'Edit')
          page.find("button.close").click
        end

        expect(page).to_not have_selector(".panel.location")
        expect(current_url).to match /\/#\/locations$/
      end

      scenario 'creating a new location' do
        visit "/#/locations/new"
        expect(page).to have_selector(".modal-dialog", count: 1)
        within(".modal-dialog") do
          expect(page).to have_text "New location"
          page.fill_in "Name", with: "a new location name"
          page.select building.name, from: "Building"
          click_button "Create"
        end
        flash_is "Location successfully created"
        visit "/#/locations"
        within ".locations-locations" do
          expect(page).to have_text "a new location name"
        end
        expect(page).to_not have_selector ".modal-dialog"
      end

      scenario 'editing location' do
        page.find(".locations-location a", text: location1.name).click
        expect(page).to have_selector(".panel.location")
        within(".panel.location") do
          click_link "Edit"
        end
        expect(current_url).to match "/#/locations"
        expect(page).to have_selector(".modal-dialog", count: 1)
        within(".modal-dialog") do
          expect(page).to have_text "Edit location “#{location1.name}”"
          page.fill_in "Name", with: "another location name"
          click_button "Update"
        end
        flash_is "Location successfully updated"
        visit "/#/locations"
        within ".locations-locations" do
          expect(page).to have_text "another location name"
        end
        expect(page).to_not have_selector ".modal-dialog"
      end

      scenario 'destroying a location' do
        visit "/#/locations/#{location1.id}"
        expect(page).to have_selector(".panel.location", count: 1)
        within(".panel.location") do
          expect(page).to have_text "Location “#{location1.name}”"
          click_link "Destroy"
        end
        expect(page).to have_bootbox /Are you sure/
        page.accept_bootbox
        flash_is "Location successfully destroyed"
      end
    end
  end
end
