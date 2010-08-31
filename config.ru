Dir['config','lib','lib/*/'].each do |dir|
  dir = File.join(File.dirname(__FILE__),dir)
  $LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)
end

require 'trst_pub'
require 'trst_sys'

map '/' do
  run TrstPub.new
end

map '/srv' do
  run TrstSys.new
end
