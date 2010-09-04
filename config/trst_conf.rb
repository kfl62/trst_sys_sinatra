# encoding: utf-8
Dir['config','lib','lib/*/'].each do |dir|
  dir = File.join(File.expand_path('../',File.dirname(__FILE__)),dir)
  $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
end
require 'bundler/setup'
require 'sinatra/base'
require 'haml'
require 'compass'
require 'trst_helpers_haml'
require 'trst_helpers_sinatra'
Haml::Helpers.class_eval("include Trst::Haml::Helpers")
Sinatra::Base.class_eval("include Trst::Sinatra::Helpers")
Sinatra::Base.set(:root, File.expand_path('..', File.dirname(__FILE__)))
Sinatra::Base.set(:views, File.join(File.expand_path('..', File.dirname(__FILE__)), 'src'))
Sinatra::Base.set(:logging, true)
Sinatra::Base.set(:haml, {:format => :html5, :attr_wrapper => '"'})
Sinatra::Base.configure do
  compass_config = File.join(File.dirname(__FILE__), 'compass.rb')
  Compass.add_project_configuration(compass_config) \
    unless Compass.configuration.name == compass_config
end
#require 'secret'
require 'mongoid'
Mongoid.configure do |config|
  config.master = Mongo::Connection.new('localhost').db('development')
end
# models
require 'pg_pub'
require 'pg_sys'
require 'trst_user'
# controllers
require 'trst_auth'
require 'trst_pub'
require 'trst_sys'

