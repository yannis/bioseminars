guard 'sass', :output => '' do
  watch(/^public\/stylesheets\/sass\/(.*)/)
  # watch('^_sass/(.*)')
  # watch('^scss/(.*))
end

guard 'test', :all_on_start => false, :all_after_pass => false, :keep_failed => false do
  watch(/^lib\/(.*)\.rb/)                              { |m| "test/lib/#{m[1]}_test.rb" }
  watch(/^test\/(.*)_test.rb/)
  watch(/^test\/test_helper.rb/)                       { "test" }

  # Rails example
  watch(/^app\/models\/(.*)\.rb/)                       { |m| "test/unit/#{m[1]}_test.rb" }
  watch(/^app\/controllers\/(.*)\.rb/)                  { |m| "test/functional/#{m[1]}_test.rb" }
  watch(/^app\/controllers\/application_controller.rb/) { "test/functional" }
  watch(/^app\/controllers\/application_controller.rb/) { "test/integration" }
  watch(/^app\/views\/(.*)\.rb/)                        { "test/integration" }
  watch(/^test\/factories.rb/)                         { "test/unit" }
end

guard 'livereload', :api_version => '1.5' do
  watch(/app\/.+\.(erb|haml)$/)
  watch(/app\/helpers\/.+\.rb$/)
  watch(/public\/.+\.(css|js|html)$/)
  watch(/config\/locales\/.+\.yml$/)
end
