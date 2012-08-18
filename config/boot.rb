# encoding: utf-8

TRST_ROOT = File.expand_path('../',File.dirname(__FILE__))
TRST_ENV  = ENV['RACK_ENV'] || 'development'
# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'ostruct'
Bundler.require(:default, TRST_ENV)
# Load libraries
Dir.glob(File.join(TRST_ROOT, 'lib','**','*.rb')).each{|r| require r}
# Load configurations
Dir.glob(File.join(TRST_ROOT, 'config','**','*.rb')).each{|r| require r}
# Initialize path for Trst
Dir['system/*'].each do |dir|
  dir = File.join(File.expand_path('..',File.dirname(__FILE__)),dir)
  $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
end
# Add path for translations and default language
I18n.load_path += Dir.glob(File.join(TRST_ROOT, 'system','i18n','**','*','*.yml'))
I18n.default_locale = :ro
# Sintra default settings
Sinatra::Base.set(:root, TRST_ROOT)
Sinatra::Base.set(:cdn,  true)
Sinatra::Base.mime_type(:otf, ' font/otf')
Sinatra::Base.mime_type(:ttf,  'font/ttf')
Sinatra::Base.mime_type(:eot,  'application/vnd.ms-fontobject')
Sinatra::Base.mime_type(:svg,  'image/svg+xml')
Sinatra::Base.mime_type(:woff, 'font/woff')
