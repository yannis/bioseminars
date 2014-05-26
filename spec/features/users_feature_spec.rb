require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'users', js: true do

  let!(:user1) {create :user}
  let!(:user2) {create :user}
  let!(:user3) {create :user}
  let!(:user4) {create :user}
  let!(:user5) {create :user}

  context "when not logged in" do
    before {
      embersignout
      visit "/"
    }

    scenario 'showing the list of users' do
      visit "/#/users"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end

    scenario 'Showing a user' do
      visit "/#/users/#{user1.id}"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end

    scenario "creating a user" do
      visit "/#/users/new"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end

    scenario "editing a user" do
      visit "/#/users/#{user1.id}/edit"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end
  end

  context "when signed in as member" do
    let!(:member) {create :user, admin: false}

    before {
      embersignin member
      visit "/"
    }

    scenario 'showing the list of users' do
      visit "/#/users"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end

    scenario 'Showing the current user' do
      click_link member.name
      click_link "Settings"
      expect(page).to have_selector(".panel.user", count: 1)
      within(".panel.user") do
        expect(page).to have_text(member.name, count: 1)
        expect(page).to have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.user")
      expect(current_url).to match /\/#\/calendar\//
    end

    scenario 'Showing a user' do
      visit "/#/users/#{user1.id}"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end

    scenario 'creating a new user'do
      visit "/#/users/new"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end

    scenario 'editing the current user' do
      visit "/#/users/#{member.id}/edit"
      expect(page).to have_selector(".modal-dialog", count: 1)
      within(".modal-dialog") do
        expect(page).to have_text "Edit user “#{member.name}”"
        page.fill_in "Name", with: "another user name"
        click_button "Update"
      end
      flash_is "User successfully updated"
      visit "/#/users/#{member.id}"
      within ".panel.user" do
        expect(page).to have_text "another user name"
      end
      expect(page).to_not have_selector ".modal-dialog"
    end

    scenario 'editing a user' do
      visit "/#/users/#{user1.id}/edit"
      it_does_not_authorize_and_redirect_to /\/#\/calendar\//
    end
  end

  context "when signed in as admin" do
    let(:admin) {create :user, admin: true}
    before {
      embersignout
      embersignin admin
    }

    scenario 'showing the list of users' do
      visit "/#/users"
      expect(page).to have_title "All users"
      expect(page).to have_selector(".users-users")
      within(".users-users") do
        expect(page).to have_selector(".users-user", count: 6)
        expect(page).to have_selector(".users-user a", text: user1.name, count: 1)
        expect(page).to have_selector(".users-user a", text: admin.name, count: 1)
      end
    end

    scenario 'Showing a user'  do
      visit "/#/users"
      within(".users-users") do
        click_link user1.name
      end
      expect(current_url).to match /\/#\/users\/#{user1.id}$/
      expect(page).to have_selector(".panel.user", count: 1)
      within(".panel.user") do
        expect(page).to have_text(user1.name, count: 1)
        expect(page).to have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.user")
      expect(current_url).to match /\/#\/users$/
    end

    scenario 'creating a new user' do
      visit "/#/users/new"
      expect(page).to have_selector(".modal-dialog", count: 1)
      within(".modal-dialog") do
        expect(page).to have_text "New user"
        page.fill_in "Name", with: "a new user name"
        page.fill_in "Email", with: "anemail@bioseminars.dev"
        page.fill_in "Password", with: "apassword"
        page.fill_in "Password confirmation", with: "apassword"
        click_button "Create"
      end
      flash_is "User successfully created"
      expect(current_url).to match /\/#\/users\//
      visit "/#/users"
      within ".users-users" do
        expect(page).to have_text "a new user name"
      end
      expect(page).to_not have_selector ".modal-dialog"
    end

    scenario 'editing user' do
      visit "/#/users"
      page.find(".users-user a", text: user1.name).click
      expect(page).to have_selector(".panel.user")
      within(".panel.user") do
        click_link "Edit"
      end
      expect(page).to have_selector(".modal-dialog", count: 1)
      within(".modal-dialog") do
        expect(page).to have_text "Edit user “#{user1.name}”"
        page.fill_in "Name", with: "another user name"
        click_button "Update"
      end
      flash_is "User successfully updated"
      visit "/#/users"
      within ".users-users" do
        expect(page).to have_text "another user name"
      end
      expect(page).to_not have_selector ".modal-dialog"
    end

    scenario 'destroying a user' do
      visit "/#/users/#{user1.id}"
      expect(page).to have_selector(".panel.user", count: 1)
      within(".panel.user") do
        expect(page).to have_text "User “#{user1.name}”"
        click_link "Destroy"
      end
      expect(page).to have_bootbox /Are you sure/
      page.accept_bootbox
      flash_is "User successfully destroyed"
    end
  end
end
