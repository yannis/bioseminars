require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff

feature 'categories', js: true do

  let!(:category1) {create :category}
  let!(:category2) {create :category}
  let!(:category3) {create :category}
  let!(:category4) {create :category}
  let!(:category5) {create :category}
  let!(:building) {create :building}

  context "when not logged in"do
    before {
      embersignout
    }

    context "when showing a category" do
      scenario "the category panel don't show the archiving link"  do
        visit "/#/categories/#{category1.id}"
        within(".panel.category") do
          expect(page).to_not have_selector("a.seminar-adminlinks-archiving")
        end
      end
    end

    context "when showing a category and an archived category exists" do
      let!(:archived_category){create :category, archived_at: 2.weeks.ago}
      scenario "the categories list don't show archived categories"  do
        visit "/#/categories/"
        within(".categories-categories") do
          expect(page).to_not have_selector(".categories-category.archived")
          expect(page).to have_selector(".categories-category", count: 5)
        end
      end
    end
  end

  context "when not logged in as member"do
    let(:user) {create :user}
    before {
      embersignout
      embersignin user
    }

    context "when showing a category" do
      scenario "the category panel don't show the archiving link"  do
        visit "/#/categories/#{category1.id}"
        within(".panel.category") do
          expect(page).to_not have_selector("a.seminar-adminlinks-archiving")
        end
      end
    end

    context "when showing a category and an archived category exists" do
      let!(:archived_category){create :category, archived_at: 2.weeks.ago}
      scenario "the categories list don't show archived categories"  do
        visit "/#/categories/"
        within(".categories-categories") do
          expect(page).to_not have_selector(".categories-category.archived")
          expect(page).to have_selector(".categories-category", count: 5)
        end
      end
    end
  end

  context "when logged in as admin"do
    let(:user) {create :user, admin: true}
    before {
      embersignout
      embersignin user
    }

    context "when showing a category" do
      scenario "The category panel don't show the archived class"  do
        visit "/#/categories"
        within(".categories-categories") do
          expect(page).to_not have_selector(".categories-category.archived")
        end
        visit "/#/categories/#{category1.id}"
        within(".panel.category") do
          expect(page).to have_selector("a.seminar-adminlinks-archiving", count: 1, text: "Toggle archive status")
          page.find("a.seminar-adminlinks-archiving").click
        end
        flash_is "Category successfully archived"
        visit "/#/categories"
        within(".categories-categories") do
          expect(page).to have_selector(".categories-category.archived", count: 1)
        end
        visit "/#/categories/#{category1.id}"
        within(".panel.category.archived") do
          expect(page).to have_selector("a.seminar-adminlinks-archiving", count: 1, text: "Toggle archive status")
          page.find("a.seminar-adminlinks-archiving").click
        end
        flash_is "Category successfully unarchived"
        visit "/#/categories"
        within(".categories-categories") do
          expect(page).to_not have_selector(".categories-category.archived")
        end
      end
    end

    context "when showing a category and an archived category exists" do
      let!(:archived_category){create :category, name: "archived category", archived_at: 2.weeks.ago}
      scenario "the categories list shows archived categories"  do
        visit(current_path) #required to reload the page
        visit "/#/categories/"
        within(".categories-categories") do
          expect(page).to have_selector(".categories-category.archived", count: 1)
          expect(page).to have_selector(".categories-category", count: 6)
        end
      end
    end
  end
end
