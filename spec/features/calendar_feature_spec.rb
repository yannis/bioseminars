require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'Calendar', js: true do
  context "with a few seminars" do
    let!(:category1) {create :category}
    let!(:category2) {create :category}
    let!(:seminar1) {create :seminar, categories: [category1], start_at: 1.days.from_now}
    let!(:seminar2) {create :seminar, categories: [category2], start_at: 2.days.from_now}
    let!(:seminar3) {create :seminar, categories: [category1], start_at: 2.days.from_now+2.hours}
    let!(:seminar4) {create :seminar, categories: [category2], start_at: 3.days.from_now+2.hours}
    let!(:seminar5) {create :seminar, categories: [category1], start_at: 2.month.from_now+2.hours}
    let!(:seminar6) {create :seminar, categories: [category2], start_at: 2.month.from_now+36.hours}
    let!(:seminar7) {create :seminar, categories: [category1], start_at: 2.month.ago+2.hours}
    let!(:seminar8) {create :seminar, categories: [category2], start_at: 2.month.ago+36.hours}

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

      scenario "I click on a seminar and see the tooltip", :focus do
        visit "/#/calendar/month/2014/05/09/seminar/#{seminar1.id}"
        sleep 30
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-event-#{seminar1.id}", count: 1
          expect(page).to_not have_selector ".qtip"
          page.find(".fc-event-#{seminar1.id}").click
          expect(page).to have_selector ".qtip", count: 1
        end
      end
    end

    for role in ["member", "admin"]
      context "when signed in as #{role}" do
        let(:user) {create :user, admin: (role == "admin")}
        before {
          embersignout
          embersignin user
        }

        scenario "I see the calendar and (+) links to add events in days" do
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
          expect(current_url).to match /\/#\/seminars\/new_with_date/
          expect(page).to have_text "Create a seminar on"
          expect(page).to have_selector ".panel.seminar-form", count: 1
        end
      end
    end
  end
end
