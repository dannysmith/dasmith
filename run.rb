# This file just pulls everything together.
# launch it with irb -r ./run.rb
require 'bundler/setup'
require 'sinatra/base'
require 'pry'

Dir[File.dirname(__FILE__) + '/lib/*'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/models/*'].each { |f| require f }

require './dasmith'
