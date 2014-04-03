require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'Seminar series toggling', js: true do
  context "The calendar with a few seminars" do
    let!(:category1) {create :category}
    let!(:category2) {create :category}
    let!(:seminar1) {create :seminar, categories: [category1], start_at: 1.days.from_now}
    let!(:seminar2) {create :seminar, categories: [category1], start_at: 2.days.from_now}
    let!(:seminar3) {create :seminar, categories: [category2], start_at: 1.days.from_now+2.hours}
    let!(:seminar4) {create :seminar, categories: [category2], start_at: 2.days.from_now+2.hours}

    before {
      embersignout
    }

    scenario "I see the calendar and seminars" do
      visit "/"
      expect(page).to have_selector "#calendar.fc", count: 1
      expect(page).to have_selector ".panel.calendar-categories", count: 1
      within ".panel.calendar-categories" do
        expect(page).to have_selector "tr.calendar-category", count: 2
      end
      within "#calendar.fc" do
        expect(page).to have_selector ".fc-event", count: 4
      end

      page.uncheck category1.name
      within "#calendar.fc" do
        expect(page).to have_selector ".fc-event", count: 2
      end

      page.uncheck category2.name
      within "#calendar.fc" do
        expect(page).to_not have_selector ".fc-event"
      end

      page.check category1.name
      within "#calendar.fc" do
        expect(page).to have_selector ".fc-event", count: 2
      end

      page.check category2.name
      within "#calendar.fc" do
        expect(page).to have_selector ".fc-event", count: 4
      end
    end

    scenario "I see the list of seminars and categories" do
      visit "/#/seminars/next"
      expect(page).to have_selector "ul.seminars-seminars", count: 1
      expect(page).to have_selector ".panel.calendar-categories", count: 1
      within ".panel.calendar-categories" do
        expect(page).to have_selector "tr.calendar-category", count: 2
      end
      within "ul.seminars-seminars" do
        expect(page).to have_selector "li.seminars-seminar", count: 4
      end

      page.uncheck category1.name
      within "ul.seminars-seminars" do
        expect(page).to have_selector "li.seminars-seminar", count: 2
      end

      page.uncheck category2.name
      within "ul.seminars-seminars" do
        expect(page).to_not have_selector "li.seminars-seminar"
      end

      page.check category1.name
      within "ul.seminars-seminars" do
        expect(page).to have_selector "li.seminars-seminar", count: 2
      end

      page.check category2.name
      within "ul.seminars-seminars" do
        expect(page).to have_selector "li.seminars-seminar", count: 4
      end

      page.check category2.name
    end
  end
end
