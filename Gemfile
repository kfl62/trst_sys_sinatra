source :rubygems

gem 'rake'
gem 'sinatra', :require => "sinatra/base"
gem 'sinatra-flash', :require => "sinatra/flash"
gem 'rack-rewrite', :require => "rack/rewrite"

# Component requirements
gem 'coffee-script'
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'compass'
gem 'haml'
gem 'mongoid', github: "mongoid"
gem 'rdiscount'

# Development requirements
group :development do
  gem 'thin'
  gem 'wirble'
  gem 'guard-livereload'
end
# Test requirements
group :test do
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
end
