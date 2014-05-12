require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'Internal seminars', js: true do
  context "An internal seminar in the calendar" do
    let!(:category1) {create :category}
    let!(:category2) {create :category}
    let!(:seminar1) {create :seminar, categories: [category1], start_at: 1.days.from_now}
    let!(:seminar2) {create :seminar, categories: [category2], start_at: 2.days.from_now}
    let!(:seminar3) {create :seminar, categories: [category1], start_at: 3.days.from_now, internal: true}
    let!(:seminar4) {create :seminar, categories: [category2], start_at: 4.days.from_now, internal: true}

    context "when not logged in" do
      before { embersignout }

      scenario "is not show by default" do
        visit "/"
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-event", count: 2
        end

        page.check "internal_seminars_selection"
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-event", count: 4
        end

        page.uncheck "internal_seminars_selection"
        within "#calendar.fc" do
          expect(page).to have_selector ".fc-event", count: 2
        end
      end
    end
  end
end
