require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'seminars', js: true do
  let!(:category1) {create :category, name: "category1"}
  let!(:category2) {create :category, name: "category2"}
  let!(:category3) {create :category, name: "category3"}

  context "when not logged in" do
    before { embersignout }
    scenario 'showing a list of 5 seminars' do
      visit "/#/feeds"
      expect(page).to have_title "Get your personal seminar feed"
      expect(page).to have_text "/api/v2/seminars.json?internal=true&scope=future&order=asc&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      select "all", from: "Time scope"
      expect(page).to have_text "/api/v2/seminars.json?internal=true&scope=all&order=asc&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      select "ics", from: "Format"
      expect(page).to have_text "/api/v2/seminars.ics?internal=true&scope=all&order=asc&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      uncheck "Include internal (private) seminars?"
      expect(page).to have_text "/api/v2/seminars.ics?internal=false&scope=all&order=asc&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      uncheck "Sort seminars by ascending time?"
      expect(page).to have_text "/api/v2/seminars.ics?internal=false&scope=all&order=desc&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      fill_in "After date", with: ""
      fill_in "After date", with: "2015-01-01"
      expect(page).to have_text "/api/v2/seminars.ics?internal=false&scope=all&order=desc&after=20150101&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      fill_in "Before date", with: ""
      fill_in "Before date", with: "2015-12-31"
      expect(page).to have_text "/api/v2/seminars.ics?internal=false&scope=all&order=desc&after=20150101&before=20151231&limit=20&categories=#{category1.id},#{category2.id},#{category3.id}"
      uncheck category1.name
      expect(page).to have_text "/api/v2/seminars.ics?internal=false&scope=all&order=desc&after=20150101&before=20151231&limit=20&categories=#{category2.id},#{category3.id}"
    end
  end
end
