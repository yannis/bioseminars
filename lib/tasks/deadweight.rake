# lib/tasks/deadweight.rake
# begin
#  require 'deadweight'
# rescue LoadError
# end
# 
#  Deadweight::RakeTask.new do |dw|
#    # dw.mechanize = true
# 
#    dw.root = 'http://localhost:3000'
# 
#    dw.stylesheets = %w( /stylesheets/application.css )
# 
#    dw.pages = %w( / /seminars /seminars/14 )
# 
#    # dw.pages << proc {
#    #   fetch('/login')
#    #   form = agent.page.forms.first
#    #   form.username = 'username'
#    #   form.password = 'password'
#    #   agent.submit(form)
#    #   fetch('/secret-page')
#    # }
# 
#    dw.ignore_selectors = /flash|notice|warning|flash_notice|flash_error|errorExplanation|fieldWithErrors/
#    
#  end