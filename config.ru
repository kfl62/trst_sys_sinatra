# encoding: utf-8
require './config/trst_conf'

map '/' do
  run TrstPub.new
end

map '/srv' do
  run TrstSys.new
end
