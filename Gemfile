source 'https://rubygems.org'

gem 'rake'
gem 'sinatra', require: "sinatra/base"
gem 'sinatra-flash', require: "sinatra/flash"
gem 'rack-rewrite', require: "rack/rewrite"

# Component requirements
gem 'coffee-script'
gem 'bcrypt'
gem 'compass'
gem 'haml'
gem 'mongoid', :git => 'https://github.com/kfl62/mongoid.git', :branch => '3.1.0-stable'
gem 'rdiscount'
gem 'prawn'
gem 'prawn-templates'
gem 'prawn-table'
# Disable gruff for now (deploy problem wrong version of ImageMagick on my server)
#gem 'rmagick'
#gem 'gruff', github: 'topfunky/gruff'
gem 'googlecharts'

# Development requirements
group :development do
  gem 'thin'
  gem 'wirble'
end
# Test requirements
group :test do
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
end
