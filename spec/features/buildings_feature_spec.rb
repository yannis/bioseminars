require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'buildings', js: true do

  let!(:building1) {create :building}
  let!(:building2) {create :building}
  let!(:building3) {create :building}
  let!(:building4) {create :building}
  let!(:building5) {create :building}

  context "when not logged in" do
    before { embersignout }

    scenario 'showing the list of buildings' do
      visit "/#/buildings"
      expect(page).to have_title "All buildings"
      expect(page).to have_selector(".buildings-buildings")
      within(".buildings-buildings") do
        expect(page).to have_selector(".buildings-building", count: 5)
        expect(page).to have_selector(".buildings-building a", text: building1.name, count: 1)
      end
    end

    scenario 'Showing a building' do
      visit "/#/buildings"
      within(".buildings-buildings") do
        click_link building1.name
      end
      expect(current_url).to match /\/#\/buildings\/#{building1.id}$/
      expect(page).to have_selector(".panel.building", count: 1)
      within(".panel.building") do
        expect(page).to have_text(building1.name, count: 1)
        expect(page).to_not have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.building")
      expect(current_url).to match /\/#\/buildings$/
    end

    scenario "creating a building" do
      visit "/#/buildings/new"
      it_does_not_authorize_and_redirect_to /\/#\/buildings$/
    end

    scenario "editing a building" do
      visit "/#/buildings/#{building1.id}/edit"
      it_does_not_authorize_and_redirect_to /\/#\/buildings$/
    end
  end

  for role in ["member", "admin"]
    context "when signed in as #{role}" do
      let(:user) {create :user, admin: (role == "admin")}
      before {
        embersignout
        embersignin user
      }

      scenario 'showing the list of buildings'do
        visit "/#/buildings"
        expect(page).to have_title "All buildings"
        expect(page).to have_selector(".buildings-buildings")
        within(".buildings-buildings") do
          expect(page).to have_selector(".buildings-building", count: 5)
          expect(page).to have_selector(".buildings-building a", text: building1.name, count: 1)
        end
      end

      scenario 'Showing a building'  do
        visit "/#/buildings"
        within(".buildings-buildings") do
          click_link building1.name
        end
        expect(current_url).to match /\/#\/buildings\/#{building1.id}$/
        expect(page).to have_selector(".panel.building", count: 1)
        within(".panel.building") do
          expect(page).to have_text(building1.name, count: 1)
          expect(page).to have_selector("a", text: 'Edit')
          page.find("button.close").click
        end

        expect(page).to_not have_selector(".panel.building")
        expect(current_url).to match /\/#\/buildings$/
      end

      scenario 'creating a new building' do
        visit "/#/buildings/new"
        expect(page).to have_selector(".modal-dialog", count: 1)
        within(".modal-dialog") do
          expect(page).to have_text "New building"
          page.fill_in "Name", with: "a new building name"
          click_button "Create"
        end
        flash_is "Building successfully created"
        visit "/#/buildings"
        within ".buildings-buildings" do
          expect(page).to have_text "a new building name"
        end
        expect(page).to_not have_selector ".modal-dialog"
      end

      scenario 'editing building' do
        visit "/#/buildings"
        page.find(".buildings-building a", text: building1.name).click
        expect(page).to have_selector(".panel.building")
        within(".panel.building") do
          click_link "Edit"
        end
        # expect(current_url).to match "buildings\/#{building1.id}\/edit"
        expect(page).to have_selector(".modal-dialog", count: 1)
        within(".modal-dialog") do
          expect(page).to have_text "Edit building"
          page.fill_in "Name", with: "another building name"
          click_button "Update"
        end
        flash_is "Building successfully updated"
        expect(page).to_not have_selector ".modal-dialog"
        visit "/#/buildings"
        within ".buildings-buildings" do
          expect(page).to have_text "another building name"
        end
      end

      scenario 'destroying a building' do
        visit "/#/buildings/#{building1.id}"
        expect(page).to have_selector(".panel.building", count: 1)
        within(".panel.building") do
          expect(page).to have_text "Building “#{building1.name}”"
          click_link "Destroy"
        end
        expect(page).to have_bootbox /Are you sure/
        page.accept_bootbox
        flash_is "Building successfully destroyed"
      end
    end
  end
end
