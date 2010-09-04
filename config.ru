# encoding: utf-8
require './config/trst_conf'
require 'rack-flash'

use Rack::Session::Cookie, :secret => 'zsdgryst34kkufklfSwsqwess'
use Rack::Flash

map '/' do
  run TrstPub.new
end

map '/auth' do
  run TrstAuth.new
end

map '/srv' do
  run TrstSys.new
end

map '/utils' do
  run TrstUtils.new
end
