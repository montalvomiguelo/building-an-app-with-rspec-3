source 'https://rubygems.org'

ruby '2.5.1'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'sequel'
gem 'nokogiri'

group :production do
  gem 'mysql2'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'database_cleaner'
end
