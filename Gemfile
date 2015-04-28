source 'https://rubygems.org'
ruby '2.1.5'

gem 'rake'

# Sinatra
gem 'sinatra'
gem 'sinatra-contrib'

# Tests
gem 'cucumber'
gem 'rspec'
gem 'rack-test'
gem 'coveralls', require: false

# Server
gem 'thin'
gem 'puma'

# Databases
gem 'pg'

# Front-end
gem 'sass'
gem 'bourbon'

# Others
gem 'activesupport'
gem 'readit'
gem 'redcarpet', git: 'https://github.com/vmg/redcarpet.git'
gem 'pygments.rb'
gem 'builder'
gem 'json'
gem 'evernote_oauth'

group :production do
  gem 'newrelic_rpm'
end

group :development do

  # OSX Notifications
  gem 'rb-fsevent'
  gem 'growl' # also install growlnotify

  gem 'rb-readline'

  # Minification
  gem 'jammit'
  gem 'uglifier'

  # Guard
  gem 'foreman'
  gem 'guard', '~> 2'
  gem 'guard-bundler'
  gem 'guard-foreman'
  gem 'rack-livereload'
  gem 'guard-livereload'
  gem 'guard-sass'
  gem 'guard-jammit', git: 'https://github.com/dannysmith/guard-jammit.git'
  gem 'guard-shell'
  gem 'shotgun'
  # gem 'guard-shotgun', git:'https://github.com/rchampourlier/guard-shotgun.git'
  # gem 'guard-migrate' # For ActiveRecord https://github.com/guard/guard-migrate

  # Debugging
  gem 'pry', '>= 0.9.12'
  gem 'awesome_print'
  gem 'rubocop'

  # Better Errors
  gem 'binding_of_caller'
  gem 'better_errors'

end
