source 'https://rubygems.org'

gem 'rake'
gem 'sinatra', require: "sinatra/base"
gem 'sinatra-flash', require: "sinatra/flash"
gem 'rack-rewrite', require: "rack/rewrite"

# Component requirements
gem 'coffee-script'
gem 'bcrypt'
gem 'haml'
gem 'sass'
gem 'compass'
gem 'mongoid', :git => 'https://github.com/kfl62/mongoid.git'
gem 'rdiscount'
gem 'prawn', '1.0.0'  # hotfix v0.3.1
gem 'prawn-templates'
#gem 'prawn-table'    # hotfix v0.3.1

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
