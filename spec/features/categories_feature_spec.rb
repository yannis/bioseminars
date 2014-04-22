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
    before { embersignout
      visit "/#/categories"
    }

    scenario 'showing the list of categories' do
      expect(page).to have_title "All categories"
      expect(page).to have_selector(".categories-categories")
      within(".categories-categories") do
        expect(page).to have_selector(".categories-category", count: 5)
        expect(page).to have_selector(".categories-category a", text: category1.name, count: 1)
      end
    end

    scenario 'Showing a category' do
      within(".categories-categories") do
        click_link category1.name
      end
      expect(current_url).to match /\/#\/categories\/#{category1.id}$/
      expect(page).to have_selector(".panel.category", count: 1)
      within(".panel.category") do
        expect(page).to have_text(category1.name, count: 1)
        expect(page).to_not have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.category")
      expect(current_url).to match /\/#\/categories$/
    end

    scenario "creating a category" do
      visit "/#/categories/new"
      within(".notifications") do
        expect(page).to have_text "You are not authorized to access this page"
      end
      expect(current_url).to match /\/#\/categories$/
    end

    scenario "editing a category"  do
      visit "/#/categories/#{category1.id}/edit"
      within(".notifications") do
        expect(page).to have_text "You are not authorized to access this page"
      end
      expect(current_url).to match /\/#\/categories$/
    end
  end

  for role in ["member", "admin"]
    context "when signed in as #{role}" do
      let(:user) {create :user, admin: (role == "admin")}
      before {
        embersignout
        embersignin user
      }

      scenario 'showing the list of categories' do
        visit "/#/categories"
        expect(page).to have_title "All categories"
        expect(page).to have_selector(".categories-categories")
        within(".categories-categories") do
          expect(page).to have_selector(".categories-category", count: 5)
          expect(page).to have_selector(".categories-category a", text: category1.name, count: 1)
        end
      end

      scenario 'Showing a category'  do
        visit "/#/categories"
        within(".categories-categories") do
          click_link category1.name
        end
        expect(current_url).to match /\/#\/categories\/#{category1.id}$/
        expect(page).to have_selector(".panel.category", count: 1)
        within(".panel.category") do
          expect(page).to have_text(category1.name, count: 1)
          expect(page).to have_selector("a", text: 'Edit')
          page.find("button.close").click
        end

        expect(page).to_not have_selector(".panel.category")
        expect(current_url).to match /\/#\/categories$/
      end

      scenario 'creating a new category' do
        visit "/#/categories/new"
        expect(page).to have_selector(".panel.category-form", count: 1)
        within(".panel.category-form") do
          expect(page).to have_text "New category"
          page.fill_in "Name", with: "a new category name"
          page.fill_in "Acronym", with: "ANCN"
          click_button "Create"
        end
        flash_is "Category successfully created"
        expect(current_url).to match /\/#\/categories$/
        within ".categories-categories" do
          expect(page).to have_text "a new category name"
        end
        expect(page).to_not have_selector ".panel.category-form"
      end

      scenario 'editing category' do
        visit "/#/categories"
        page.find(".categories-category a", text: category1.name).click
        expect(page).to have_selector(".panel.category")
        within(".panel.category") do
          click_link "Edit"
        end
        expect(current_url).to match "categories\/#{category1.id}\/edit"
        expect(page).to have_selector(".panel.category-form", count: 1)
        within(".panel.category-form") do
          expect(page).to have_text "Edit category “#{category1.name}”"
          page.fill_in "Name", with: "another category name"
          page.fill_in "Acronym", with: "ACN"
          click_button "Update"
        end
        flash_is "Category successfully updated"
        visit "/#/categories"
        within ".categories-categories" do
          expect(page).to have_text "another category name"
        end
        expect(page).to_not have_selector ".panel.category-form"
      end

      scenario 'destroying a category' do
        visit "/#/categories/#{category1.id}"
        expect(page).to have_selector(".panel.category", count: 1)
        within(".panel.category") do
          expect(page).to have_text "Category “#{category1.name}”"
          click_link "Destroy"
        end
        expect(page).to have_bootbox /Are you sure/
        page.accept_bootbox
        flash_is "Category successfully destroyed"
      end
    end

    scenario "reordering as admin" do
      admin = create(:user, admin: true)
      embersignout
      embersignin admin

      visit "/#/categories"
      within(".categories-category:first-of-type") do
        expect(page).to have_selector ".category-sortable-handle"
      end
      from = page.find(".categories-categories li:nth-of-type(4) .category-sortable-handle")
      to = page.find(".categories-categories")
      drag_to from, to
      flash_is "Categories successfully reordered"
    end
  end
end
