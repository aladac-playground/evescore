# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'capistrano-rails', group: :development
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'mongoid'
gem 'omniauth-crest'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'ruby-esi'
gem 'sass-rails', '~> 5.0'
gem 'simplecov', require: false, group: :test
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'capybara', '~> 2.13'
  gem 'pry'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rubocop'
  gem 'spring'
end
