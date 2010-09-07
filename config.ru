# encoding: utf-8
require './config/trst_conf'
require 'rack-flash'
require 'rack/rewrite'

use Rack::Session::Cookie, :secret => 'zsdgryst34kkufklfSwsqwess'
use Rack::Flash
use Rack::Rewrite do
  rewrite %r{^/\w{2}/auth},  '/auth'
  rewrite %r{^/\w{2}/utils}, '/utils'
  rewrite %r{^/\w{2}/srv},   '/srv'
  rewrite %r{^/\w{2}/},      '/'
end

map '/auth' do
  run TrstAuth.new
end

map '/utils' do
  run TrstUtils.new
end

map '/srv' do
  run TrstSys.new
end

map '/' do
  run TrstPub.new
end

