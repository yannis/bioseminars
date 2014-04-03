require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'hosts', js: true do

  let!(:host1) {create :host}
  let!(:host2) {create :host}
  let!(:host3) {create :host}
  let!(:host4) {create :host}
  let!(:host5) {create :host}

  context "when not logged in" do
    before { embersignout }

    scenario 'showing the list of hosts' do
      visit "/#/hosts"
      expect(page).to have_title "All hosts"
      expect(page).to have_selector(".hosts-hosts")
      within(".hosts-hosts") do
        expect(page).to have_selector(".hosts-host", count: 5)
        expect(page).to have_selector(".hosts-host a", text: host1.name, count: 1)
      end
    end

    scenario 'Showing a host' do
      visit "/#/hosts"
      within(".hosts-hosts") do
        click_link host1.name
      end
      expect(current_url).to match /\/#\/hosts\/#{host1.id}$/
      expect(page).to have_selector(".panel.host", count: 1)
      within(".panel.host") do
        expect(page).to have_text(host1.name, count: 1)
        expect(page).to_not have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.host")
      expect(current_url).to match /\/#\/hosts$/
    end

    scenario "creating a host" do
      visit "/#/hosts"
      visit "/#/hosts/new"
      # sleep 10
      within(".notifications") do
        expect(page).to have_text "You are not authorized to access this page"
      end
      expect(current_url).to match /\/#\/hosts$/
    end

    scenario "editing a host" do
      visit "/#/hosts"
      visit "/#/hosts/#{host1.id}/edit"
      within(".notifications") do
        expect(page).to have_text "You are not authorized to access this page"
      end
      expect(current_url).to match /\/#\/hosts$/
    end
  end

  for role in ["member", "admin"]
    context "when signed in as #{role}" do
      let(:user) {create :user, admin: (role == "admin")}
      before {
        embersignout
        embersignin user
      }

      scenario 'showing the list of hosts'do
        visit "/#/hosts"
        expect(page).to have_title "All hosts"
        expect(page).to have_selector(".hosts-hosts")
        within(".hosts-hosts") do
          expect(page).to have_selector(".hosts-host", count: 5)
          expect(page).to have_selector(".hosts-host a", text: host1.name, count: 1)
        end
      end

      scenario 'Showing a host'  do
        visit "/#/hosts"
        within(".hosts-hosts") do
          click_link host1.name
        end
        expect(current_url).to match /\/#\/hosts\/#{host1.id}$/
        expect(page).to have_selector(".panel.host", count: 1)
        within(".panel.host") do
          expect(page).to have_text(host1.name, count: 1)
          expect(page).to have_selector("a", text: 'Edit')
          page.find("button.close").click
        end

        expect(page).to_not have_selector(".panel.host")
        expect(current_url).to match /\/#\/hosts$/
      end

      scenario 'creating a new host' do
        visit "/#/hosts"
        visit "/#/hosts/new"
        expect(page).to have_selector(".panel.host-form", count: 1)
        within(".panel.host-form") do
          expect(page).to have_text "New host"
          page.fill_in "Name", with: "a new host name"
          page.fill_in "Email", with: "anew@email"
          click_button "Create"
        end
        flash_is "Host successfully created"
        expect(current_url).to match /\/#\/hosts$/
        within ".hosts-hosts" do
          expect(page).to have_text "a new host name"
        end
        expect(page).to_not have_selector ".panel.host-form"
      end

      scenario 'editing host' do
        visit "/#/hosts"
        page.find(".hosts-host a", text: host1.name).click
        expect(page).to have_selector(".panel.host")
        within(".panel.host") do
          click_link "Edit"
        end
        expect(current_url).to match "hosts\/#{host1.id}\/edit"
        expect(page).to have_selector(".panel.host-form", count: 1)
        within(".panel.host-form") do
          expect(page).to have_text "Edit host “#{host1.name}”"
          page.fill_in "Name", with: "another host name"
          page.fill_in "Email", with: "another@email"
          click_button "Update"
        end
        flash_is "Host successfully updated"
        visit "/#/hosts"
        within ".hosts-hosts" do
          expect(page).to have_text "another host name"
        end
        expect(page).to_not have_selector ".panel.host-form"
      end

      scenario 'destroying a host' do
        visit "/#/hosts/#{host1.id}"
        expect(page).to have_selector(".panel.host", count: 1)
        within(".panel.host") do
          expect(page).to have_text "Host “#{host1.name}”"
          click_link "Destroy"
        end
        expect(page.driver.browser.switch_to.alert.text).to match /Are you sure/
        page.driver.browser.switch_to.alert.accept
        flash_is "Host successfully destroyed"
      end
    end
  end
end
