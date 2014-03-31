
ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'pry'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

   # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.before(:each) do
    DatabaseCleaner.start
    FactoryGirl.lint
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
