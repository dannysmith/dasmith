# Rakefile
require 'rake'
require 'dotenv/tasks'
require 'dotenv-heroku/tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-t ~@integration_test -f d'
end

RSpec::Core::RakeTask.new(:spec_all) do |t|
  t.rspec_opts = '-f d'
end

task :new do
  if ARGV.length == 0
    title = 'new-article'
  else
    title = ARGV.join('-')
  end
  filename = "#{Date.today.strftime('%Y%m%d')}-#{title}.md"
  ARGV.clear

  template = "title:
article_id:
slug: #{title}\n

#!!==========================================================\n\n"

  File.open("./articles/drafts/#{filename}", 'w') { |f| f.write(template) }
  puts filename
  `vim ./articles/#{filename}`
end

task :default => :spec
