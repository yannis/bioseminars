RSpec::Matchers::define :have_bootbox do |text|
  match do |page|
    Capybara.string(page.body).has_selector?(".bootbox", text: text)
  end
end

module Capybara
  class Session
    def accept_bootbox
      within(".bootbox") do
        click_button "OK"
      end
    end

    def refuse_bootbox
      within(".bootbox") do
        click_button "Cancel"
      end
    end
  end
end
