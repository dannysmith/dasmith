# Production requires
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/content_for'
require 'readit'
require 'cgi'
require 'json'
require 'oauth'
require 'oauth/consumer'
require "evernote_oauth"

# Require MyApp
Dir[File.dirname(__FILE__) + '/lib/*'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/models/*'].each { |f| require f }

require './dasmith'

# Development Requires
if ENV['RACK_ENV'] == "development"
  require 'pry'
  require 'rack-livereload'
  # Use livereload
  use Rack::LiveReload
end

if ENV['RACK_ENV'] == "production"
  # Performance optimization
  use Rack::Deflater #Enable GZip Compression
end

run DASmith
