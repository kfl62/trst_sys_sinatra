# encoding: utf-8
app_root = File.expand_path('../',File.dirname(__FILE__))
Dir['config','lib','lib/*/'].each do |dir|
  dir = File.join(app_root,dir)
  $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
end
require 'bundler/setup'
require 'sinatra/base'
require 'haml'
require 'compass'
require 'rdiscount'
# YAML settings
YAML::ENGINE.yamler = 'syck'
# ODM
require 'mongoid'
Mongoid.configure do |config|
  config.master = Mongo::Connection.new('localhost').db('development')
  config.raise_not_found_error = false
  config.add_language('*')
end
require 'i18n'
I18n.load_path += Dir.glob(File.join(app_root, 'src','translations','*.yml'))
I18n.load_path += Dir.glob(File.join(app_root, 'lib','models','*.yml'))
I18n.default_locale = :ro
# models,controllers
required = Dir.glob(File.join(app_root, 'lib','**','*.rb'))
required.each do |r|
  require r
end
# config sinatra, haml etc.
Haml::Helpers.class_eval("include Trst::Haml::Helpers")
Sinatra::Base.class_eval("include Trst::Sinatra::Helpers")
Sinatra::Base.set(:root, app_root)
Sinatra::Base.set(:views, File.join(app_root, 'src'))
Sinatra::Base.set(:haml, {:format => :html5, :attr_wrapper => '"'})
Sinatra::Base.set(:dojo_cdn,false)
Sinatra::Base.configure do
  compass_config = File.join(File.dirname(__FILE__), 'compass.rb')
  Compass.add_project_configuration(compass_config) \
    unless Compass.configuration.name == compass_config
end
# print export to pdf
require 'prawn'
