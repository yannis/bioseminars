require 'spec_helper'
include Warden::Test::Helpers             ## including some warden magic
Warden.test_mode!                         ## telling warden we are testing stuff


feature 'seminars', js: true do

  let!(:category1) {create :category}
  let!(:category2) {create :category}
  let!(:category3) {create :category}
  let!(:seminar1) {create :seminar, categories: [category1]}
  let!(:seminar2) {create :seminar, categories: [category2]}
  let!(:seminar3) {create :seminar, categories: [category3]}
  let!(:seminar4) {create :seminar, categories: [category1]}
  let!(:seminar5) {create :seminar, categories: [category2]}
  let!(:seminar6) {create :seminar, categories: [category3]}
  let!(:seminar7) {create :seminar, categories: [category1]}
  let!(:seminar8) {create :seminar, categories: [category2]}
  # let!(:seminar9) {create :seminar}
  # let!(:seminar10) {create :seminar}

  context "when not logged in" do
    before { embersignout }

    scenario 'showing a list of 5 seminars' do
      visit "/#/seminars"
      expect(page).to have_title "All seminars"
      expect(page).to have_selector(".seminars-seminars")
      within(".seminars-seminars") do
        expect(page).to have_selector(".seminars-seminar", count: 8)
        expect(page).to have_selector(".seminars-seminar a", text: seminar1.title, count: 1)
      end

      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_text "No more seminars"
    end

    scenario "scrolling loads new seminars" do
      10.times {create :seminar}
      visit "/#/seminars"
      expect(page).to have_title "All seminars"
      expect(page).to have_selector(".seminars-seminars")
      within(".seminars-seminars") do
        expect(page).to have_selector(".seminars-seminar", count: 10)
      end

      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_selector ".data-loader"
      sleep 0.5
      within(".seminars-seminars") do
        expect(page).to have_selector(".seminars-seminar", count: 18)
      end
      page.execute_script "window.scrollBy(0,10000)"
      expect(page).to have_text "No more seminars"
    end

    scenario 'Showing a seminar' do
      visit "/#/seminars"
      within(".seminars-seminars") do
        click_link seminar1.title
      end
      expect(current_url).to match /\/#\/seminars\/#{seminar1.id}$/
      expect(page).to have_selector(".panel.seminar", count: 1)
      within(".panel.seminar") do
        expect(page).to have_text(seminar1.title, count: 1)
        expect(page).to_not have_selector("a", text: 'Edit')
        page.find("button.close").click
      end

      expect(page).to_not have_selector(".panel.seminar")
      expect(current_url).to match /\/#\/seminars$/
    end

    scenario "creating a seminar" do
      visit "/#/locations"
      visit "/#/seminars/new"
      it_does_not_authorize_and_redirect_to /\/#\/locations$/
    end

    scenario "editing a seminar" do
      visit "/"
      visit "/#/seminars/#{seminar1.id}/edit"
      it_does_not_authorize_and_redirect_to "/#/calendar/"
    end
  end

  for role in ["member", "admin"]
    context "when signed in as #{role}" do
      let(:user) {create :user, admin: (role == "admin")}
      let(:category) {create :category, name: "A category name"}
      let(:host) {create :host, name: "A host name"}
      let(:location) {create :location, name: "A conf room"}
      before {
        embersignout
        embersignin user
      }

      scenario 'showing a list of 5 seminars' do
        visit "/#/seminars"
        expect(page).to have_title "All seminars"
        expect(page).to have_selector(".seminars-seminars")
        within(".seminars-seminars") do
          expect(page).to have_selector(".seminars-seminar", count: 8)
          expect(page).to have_selector(".seminars-seminar a", text: seminar1.title, count: 1)
        end

        page.execute_script "window.scrollBy(0,10000)"
        expect(page).to have_text "No more seminars"
      end

      scenario "scrolling loads new seminars" do
        3.times {create :seminar, categories: [category1]}
        3.times {create :seminar, categories: [category2]}
        3.times {create :seminar, categories: [category3]}
        visit "/#/seminars"
        expect(page).to have_title "All seminars"
        expect(page).to have_selector(".seminars-seminars")
        all(".calendar-categories input").each{|cb| check(cb['id'])}
        within(".seminars-seminars") do
          expect(page).to have_selector(".seminars-seminar", count: 10)
        end

        page.execute_script "window.scrollBy(0,10000)"
        expect(page).to have_text "Loading data…"
        sleep 0.5
        within(".seminars-seminars") do
          expect(page).to have_selector(".seminars-seminar", count: 17)
        end
        page.execute_script "window.scrollBy(0,10000)"
        expect(page).to have_text "No more seminars"
      end

      scenario 'Showing a seminar' do
        visit "/#/seminars"
        within(".seminars-seminars") do
          click_link seminar1.title
        end
        expect(current_url).to match /\/#\/seminars\/#{seminar1.id}$/
        expect(page).to have_selector(".panel.seminar", count: 1)
        within(".panel.seminar") do
          expect(page).to have_text(seminar1.title, count: 1)
          if role == "admin"
            expect(page).to have_selector("a", text: 'Edit')
            expect(page).to have_selector("a", text: 'Duplicate')
            expect(page).to have_selector("a", text: 'Destroy')
          else
            expect(page).to_not have_selector("a", text: 'Edit')
            expect(page).to_not have_selector("a", text: 'Duplicate')
            expect(page).to_not have_selector("a", text: 'Destroy')
          end
          page.find("button.close").click
        end

        expect(page).to_not have_selector(".panel.seminar")
        expect(current_url).to match /\/#\/seminars$/
      end

      scenario 'creating a new seminar' do
        category.save
        host.save
        location.save
        # visit "/#/seminars"
        visit "/#/seminars/new"
        expect(page).to have_selector(".panel.seminar-form", count: 1)
        within(".panel.seminar-form") do
          expect(page).to have_text "Create a seminar"
          click_link "Add a category"
          first(:select, "form-seminar-categorisations").select category.name
          # page.select category.name, from: "form-seminar-categorisations"
          page.fill_in "Title", with: "a new seminar title"
          page.fill_in "Speaker name", with: "a new speaker name"
          page.fill_in "Speaker affiliation", with: "a new speaker affiliation"
          # page.fill_in "Start date and time", with: 2.hours.from_now.to_s(:ember)
          click_link "Add a host"
          # page.select host.name, from: "form-seminar-hostings"
          first(:select, "form-seminar-hostings").select host.name
          page.select location.name, from: "form-seminar-locations"
          click_button "Create"
        end
        flash_is "Seminar successfully created"
        expect(current_url).to match /\/#\/seminars/
        page.check category.name
        within ".seminars-seminars" do
          expect(page).to have_text "a new seminar title"
        end
        expect(page).to_not have_selector ".panel.seminar-form"
      end
    end
  end

  context "when signed in as member" do
    let(:user) {create :user}
    let(:category) {create :category, name: "A category name"}
    let(:host) {create :host, name: "A host name"}
    let(:location) {create :location, name: "A conf room"}
    let(:seminar_user) {create :seminar, user: user}
    before {
      embersignout
      embersignin user
    }

    scenario "editing a seminar not own by user" do
      visit "/"
      visit "/#/seminars/#{seminar1.id}"
      expect(page).to have_selector(".panel.seminar")
      within(".panel.seminar") do
        expect(page).to_not have_text("Edit")
      end
      visit "/#/seminars/#{seminar1.id}/edit"
      it_does_not_authorize_and_redirect_to "/#/seminars/#{seminar1.id}"
    end

    scenario 'editing seminar own by user' do
      visit "/"
      visit "/#/seminars/#{seminar_user.id}"
      # page.find(".seminars-seminar a", text: seminar1.title).click
      expect(page).to have_selector(".panel.seminar")
      within(".panel.seminar") do
        click_link "Edit"
      end
      expect(current_url).to match "seminars\/#{seminar_user.id}\/edit"
      expect(page).to have_selector(".panel.seminar-form", count: 1)
      within(".panel.seminar-form") do
        expect(page).to have_text "Edit seminar “#{seminar_user.title}”"
        page.fill_in "Title", with: "another seminar title"
        click_button "Update"
      end
      flash_is "Seminar successfully updated"
      visit "/#/seminars/#{seminar_user.id}"
      within ".seminar" do
        expect(page).to have_text "another seminar title"
      end
      expect(page).to_not have_selector ".panel.seminar-form"
    end

    scenario "destroying a seminar not own by user" do
      visit "/"
      visit "/#/seminars/#{seminar1.id}"
      expect(page).to have_selector(".panel.seminar")
      within(".panel.seminar") do
        expect(page).to_not have_text("Destroy")
      end
    end

    scenario 'destroying seminar own by user' do
      visit "/#/seminars"
      visit "/#/seminars/#{seminar_user.id}"
      expect(page).to have_selector(".panel.seminar")
      expect(page).to have_text seminar_user.title
      within(".panel.seminar") do
        click_link "Destroy"
      end
      expect(page.driver.browser.switch_to.alert.text).to match /Are you sure/
      page.driver.browser.switch_to.alert.accept
      # expect(current_url).to match /\/#\/seminars\/#{seminar_user.id}/
      # expect(page).to have_selector(".panel.seminar-form", count: 1)
      # within(".panel.seminar-form") do
      #   expect(page).to have_text "Edit seminar “#{seminar_user.title}”"
      #   page.fill_in "Title", with: "another seminar title"
      #   click_button "Update"
      # end
      flash_is "Seminar successfully destroyed"
      expect(page).to_not have_text seminar_user.title
    end
  end

  # context "when signed in as admin" do
  #   let(:user) {create :user, admin: true}
  #   let(:category) {create :category, name: "A category name"}
  #   let(:host) {create :host, name: "A host name"}
  #   let(:location) {create :location, name: "A conf room"}

  #   before {
  #     embersignout
  #     embersignin user
  #   }

  #   scenario 'creating a new seminar' do
  #     category.save
  #     host.save
  #     location.save
  #     visit "/#/seminars"
  #     visit "/#/seminars/new"
  #     expect(page).to have_selector(".panel.seminar-form", count: 1)
  #     within(".panel.seminar-form") do
  #       expect(page).to have_text "Create a seminar"
  #       click_link "Add a category"
  #       page.select category.name, from: "form-seminar-categorisations"
  #       page.fill_in "Title", with: "a new seminar title"
  #       page.fill_in "Speaker name", with: "a new speaker name"
  #       click_link "Add a host"
  #       page.select host.name, from: "form-seminar-hostings"
  #       page.select location.name, from: "form-seminar-locations"
  #       click_button "Create"
  #     end
  #     flash_is "Seminar successfully created"
  #     expect(current_url).to match /\/#\/seminars$/
  #     within ".seminars-seminars" do
  #       expect(page).to have_text "a new seminar name"
  #     end
  #     expect(page).to_not have_selector ".panel.seminar-form"
  #   end

  #   scenario 'editing seminar' do
  #     visit "/#/seminars"
  #     page.find(".seminars-seminar a", text: seminar1.title).click
  #     expect(page).to have_selector(".panel.seminar")
  #     within(".panel.seminar") do
  #       click_link "Edit"
  #     end
  #     expect(current_url).to match "seminars\/#{seminar1.id}\/edit"
  #     expect(page).to have_selector(".panel.seminar-form", count: 1)
  #     within(".panel.seminar-form") do
  #       expect(page).to have_text "Edit seminar “#{seminar1.name}”"
  #       page.fill_in "Name", with: "another seminar name"
  #       click_button "Update"
  #     end
  #     flash_is "Seminar successfully updated"
  #     visit "/#/seminars"
  #     within ".seminars-seminars" do
  #       expect(page).to have_text "another seminar name"
  #     end
  #     expect(page).to_not have_selector ".panel.seminar-form"
  #   end

  #   scenario 'destroying a seminar' do
  #     visit "/#/seminars/#{seminar1.id}"
  #     expect(page).to have_selector(".panel.seminar", count: 1)
  #     within(".panel.seminar") do
  #       expect(page).to have_text "Seminar “#{seminar1.title}”"
  #       click_link "Destroy"
  #     end
  #     expect(page.driver.browser.switch_to.alert.text).to match /Are you sure/
  #     page.driver.browser.switch_to.alert.accept
  #     flash_is "Seminar successfully destroyed"
  #   end
  # end
end
