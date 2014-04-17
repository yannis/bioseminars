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
    let!(:seminar5) {create :seminar, categories: [category1], start_at: 1.month.from_now+2.hours}
    let!(:seminar6) {create :seminar, categories: [category2], start_at: 1.month.from_now+36.hours}
    let!(:seminar7) {create :seminar, categories: [category1], start_at: 1.month.ago+2.hours}
    let!(:seminar8) {create :seminar, categories: [category2], start_at: 1.month.ago+36.hours}

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
          expect(page).to have_selector ".fc-event", count: 4

          within ".fc-header-left" do
            page.find(".fc-button-next").click
          end
          expect(page).to have_selector ".fc-header-title", count: 1, text: 1.month.from_now.to_date.to_s(:month_year)
          expect(page).to have_selector ".fc-event", count: 2

          within ".fc-header-left" do
            page.find(".fc-button-prev").click
          end
          expect(page).to have_selector ".fc-event", count: 4

          within ".fc-header-left" do
            page.find(".fc-button-prev").click
          end
          expect(page).to have_selector ".fc-header-title", count: 1, text: 1.month.ago.to_date.to_s(:month_year)
          expect(page).to have_selector ".fc-event", count: 2
        end
      end
    end
  end
end
