require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'seminars', js: true do

  context "when not logged in" do
    before { embersignout }
    scenario "the main navigation" do
      visit "/"
      within(".navbar") do
        expect(page).to_not have_selector "seminars-new-button"
      end
    end
  end

  for role in ["member", "admin"]
    context "when signed in as #{role}" do
      let(:user) {create :user, admin: (role == "admin")}
      before {
        embersignin user
      }

      scenario "the main navigation" do
        visit "/"
        within(".navbar") do
          expect(page).to have_selector "#nav-seminars-new-button", count: 1
        end
        click_link "nav-seminars-new-button"
        # expect(current_url).to match /\/#\/seminars\/new/
        expect(page).to have_selector ".modal-dialog", count: 1
      end
    end
  end
end
