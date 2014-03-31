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
gem 'mongoid'
gem 'rdiscount'
gem 'prawn'
gem 'prawn-templates'
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
