require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'Calendar', js: true do
  context "with a few seminars" do
    let!(:category1) {create :category}
    let!(:category2) {create :category}
    let!(:host) {create :host}
    let!(:location) {create :location}
    let!(:seminar1) {create :seminar, categories: [category1], start_at: 1.days.from_now}
    let!(:seminar2) {create :seminar, categories: [category2], start_at: 2.days.from_now}
    let!(:seminar3) {create :seminar, categories: [category1], start_at: 2.days.from_now+2.hours}
    let!(:seminar4) {create :seminar, categories: [category2], start_at: 3.days.from_now+2.hours}
    let!(:seminar5) {create :seminar, categories: [category1], start_at: 2.month.from_now+2.hours}
    let!(:seminar6) {create :seminar, categories: [category2], start_at: 2.month.from_now+24.hours}
    let!(:seminar7) {create :seminar, categories: [category1], start_at: 2.month.ago+2.hours}
    let!(:seminar8) {create :seminar, categories: [category2], start_at: 2.month.ago+24.hours}

    context "when not logged in" do
      before { embersignout }

      scenario "I see the calendar and seminars" do
        visit "/"
        expect(page).to have_selector "#calendar.fc", count: 1
        expect(page).to have_selector ".fc-header-title", count: 1, text: Date.current.to_s(:month_year)
        within ".panel.calendar-categories" do
          expect(page).to have_selector "tr.calendar-category", count: 2
        end
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-day"

          fcday = page.first(".fc-day")
          within fcday do
            expect(page).to_not have_selector ".calendar-new_seminar_link"
            sleep 10
          end

          expect(page).to have_selector ".fc-event", count: 4

          within ".fc-header-left" do
            page.find(".fc-button-next").click
            page.find(".fc-button-next").click
          end
          expect(page).to have_selector ".fc-header-title", count: 1, text: 2.month.from_now.to_date.to_s(:month_year)
          expect(page).to have_selector ".fc-event", count: 2

          within ".fc-header-left" do
            page.find(".fc-button-prev").click
            page.find(".fc-button-prev").click
          end
          expect(page).to have_selector ".fc-event", count: 4

          within ".fc-header-left" do
            page.find(".fc-button-prev").click
            page.find(".fc-button-prev").click
          end
          expect(page).to have_selector ".fc-header-title", count: 1, text: 2.month.ago.to_date.to_s(:month_year)
          expect(page).to have_selector ".fc-event", count: 2
        end
      end

      scenario "I click on a seminar and see the tooltip" do
        visit "/"
        expect(page).to_not have_selector ".qtip"
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-event-#{seminar2.id}", count: 1
          page.find(".fc-event-#{seminar2.id}").click
        end
        expect(current_url).to match /\/seminar\/#{seminar2.id}/
        expect(page).to have_selector ".qtip", count: 1, text: seminar2.title
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-event-#{seminar1.id}", count: 1
          page.find(".fc-event-#{seminar1.id}").click
        end
        expect(page).to_not have_selector ".qtip", text: seminar2.title
        expect(page).to have_selector ".qtip", count: 1, text: seminar1.title
        expect(current_url).to match /\/seminar\/#{seminar1.id}/
      end
    end

    for role in ["admin", "member"]
      context "when signed in as #{role}" do
        let(:user) {create :user, admin: (role == "admin")}
        before {
          embersignin user
        }

        scenario "I see the calendar and (+) links to add events in days" do
          visit "/"
          expect(page).to have_selector "#calendar.fc", count: 1
          expect(page).to have_selector ".fc-header-title", count: 1, text: Date.current.to_s(:month_year)
          within ".panel.calendar-categories" do
            expect(page).to have_selector "tr.calendar-category", count: 2
          end
          within "#calendar.fc" do
            expect(page).to have_selector ".fc-day"

            fcday = page.first(".fc-day")
            within fcday do
              expect(page).to have_selector ".calendar-new_seminar_link", count: 1
              click_link "(+)"
            end
          end
          expect(page).to have_text "Create a seminar on"
          expect(page).to have_selector ".modal-dialog", count: 1
          within(".modal-dialog") do

            multiple_select2 category1.name, 'form-seminar-categories'

            page.fill_in "Title", with: "a new seminar title"
            page.fill_in "Speaker name", with: "a new speaker name"
            page.fill_in "Speaker affiliation", with: "a new speaker affiliation"

            multiple_select2 host.name, 'form-seminar-hosts'

            select2 location.name, 'form-seminar-locations'

            click_button "Create"
          end

          flash_is "Seminar successfully created"

          within "#calendar.fc" do
            expect(page).to have_selector ".fc-event", text: "a new speaker name", count: 1
            page.find(".fc-event", text: "a new speaker name").click
          end
          expect(page).to have_selector ".qtip", count: 1, text: "a new seminar title"
          within ".qtip" do
            click_link "Edit"
          end
          expect(page).to have_selector ".modal-dialog", text: "a new seminar title", count: 1
          within(".modal-dialog") do
            page.fill_in "Title", with: "another seminar title"
            page.fill_in "Speaker name", with: "another speaker name"
            click_button "Update"
          end
          flash_is "Seminar successfully updated"
          within "#calendar.fc" do
            expect(page).to have_selector ".fc-event", text: "another speaker name", count: 1
            page.find(".fc-event", text: "another speaker name").click
          end
          expect(page).to have_selector ".qtip", count: 1
          within ".qtip" do
            click_link "Destroy"
          end
          expect(page).to have_bootbox /Are you sure/
          page.accept_bootbox
          flash_is "Seminar successfully destroyed"
          within "#calendar.fc" do
            expect(page).to_not have_selector ".fc-event", text: "another speaker name"
          end
        end
      end
    end
  end
end
