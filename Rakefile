#encoding: utf-8
require "thin"
require "wirble"

task :default => "doc"

desc "Generate API docs"
task :doc do
  puts "Generating API docs"
  exec "yardoc"
  puts "Done. Docs are in ./public/docs/ folder"
end

desc "Irb with DB environment loaded"
task :console do
  require "bundler/setup"
  require 'mongoid'
  app_root = File.expand_path(File.dirname(__FILE__))
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new('localhost').db('development')
    config.raise_not_found_error = false
    config.add_language('*')
  end
  require 'i18n'
  I18n.load_path += Dir.glob(File.join(app_root, 'src','translations','*.yml'))
  I18n.load_path += Dir.glob(File.join(app_root, 'lib','models','*.yml'))
  I18n.default_locale = :ro
  require 'mongoid/i18n'
  # models,controllers
  required = Dir.glob(File.join(app_root, 'lib','models','*.rb'))
  required.each do |r|
    require r
  end
  require "irb"
  ARGV.clear
  IRB.start
end

desc "Start web server"
task :thin do
  exec "thin -D start"
end
