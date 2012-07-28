#encoding: utf-8

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
    config.master = Mongo::Connection.new('localhost').db('development_master')
    config.raise_not_found_error = false
    config.add_language('*')
  end
  require 'i18n'
  I18n.load_path += Dir.glob(File.join(app_root, 'src','translations','*.yml'))
  I18n.load_path += Dir.glob(File.join(app_root, 'lib','models','*.yml'))
  I18n.default_locale = :ro
  # models,controllers
  required = Dir.glob(File.join(app_root, 'lib','models','*.rb'))
  required.each do |r|
    require r
  end
  require "irb"
  ARGV.clear
  IRB.start
end

task :daily do
  require "bundler/setup"
  require 'mongoid'
  app_root = File.expand_path(File.dirname(__FILE__))
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new('localhost').db('development_master')
    config.raise_not_found_error = false
  end
  required = Dir.glob(File.join(app_root, 'lib','models','*.rb'))
  required.each do |r|
    require r
  end
  f = File.new('./tmp/error.log', 'a')
  f.write "Check \"sum\" for expenditures - #{Date.today.to_s}\n"
  f.write "\t#{TrstAccExpenditure.daily.check_sum}\n"
  TrstFirm.first.units.each do |u|
    f.write "Check current stock for #{u.slug}\n"
    f.write "\t#{TrstFirm.pos(u.slug).current_stock_check(false,true)}\n"
  end
end

desc "Start web server"
task :thin do
  require "bundler/setup"
  exec "thin start"
end
