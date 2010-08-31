require 'bundler/setup'
require 'sinatra/base'
require 'compass'

Sinatra::Base.set(:root, File.expand_path('..', File.dirname(__FILE__)))
Sinatra::Base.set(:views, File.join(File.expand_path('..', File.dirname(__FILE__)), 'src'))
Sinatra::Base.set(:logging, true)
Sinatra::Base.set(:haml, {:format => :html5, :attr_wrapper => '"'})
Sinatra::Base.configure do
  compass_config = File.join(File.dirname(__FILE__), 'compass.rb')
  Compass.add_project_configuration(compass_config) \
    unless Compass.configuration.name == compass_config
end

