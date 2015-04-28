require 'rspec'
require "pry"
require 'coveralls'

Coveralls.wear!
# CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  # config.include Rack::Test::Methods
  # config.include SinatraSpecHelpers
end







# Require test gems
# require 'sinatra'
# require 'rack/test'
# require 'coveralls'

# Coveralls.wear!
# CodeClimate::TestReporter.start

# setup test environment
# set :environment, :test
# set :raise_errors, true
# set :logging, false

# Specify that the app is a Sinatra app
# module SinatraSpecHelpers
#   def app
#     DASmith
#   end
# end
