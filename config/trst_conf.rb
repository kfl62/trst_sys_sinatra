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
require 'trst_helpers_haml'
require 'trst_helpers_sinatra'
Haml::Helpers.class_eval("include Trst::Haml::Helpers")
Sinatra::Base.class_eval("include Trst::Sinatra::Helpers")
Sinatra::Base.set(:root, app_root)
Sinatra::Base.set(:views, File.join(app_root, 'src'))
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
require 'i18n'
I18n.load_path += Dir.glob(File.join(app_root, 'src','translations','*.yml'))
I18n.default_locale = :ro
require 'mongoid/i18n'
# models
require 'trst_book'
require 'trst_book_chapter'
require 'trst_book_page'
require 'trst_user'
# controllers
require 'trst_auth'
require 'trst_pub'
require 'trst_sys'
require 'trst_utils'

