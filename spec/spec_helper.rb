require 'yaml'
require 'redcarpet'
require 'active_support/all'
require 'dotenv'

# Test
require 'rspec'
require 'pry' unless ENV['RACK_ENV'] == 'production'
require 'fileutils'
require 'factory_girl'

Dotenv.load

# Load in everything in lib
Dir[File.dirname(__FILE__) + '/../lib/*'].each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.include FactoryGirl::Syntax::Methods

  config.before(:all) do
    FactoryGirl.reload
  end
end
