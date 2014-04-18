# Rakefile
require 'pry'

######### BLOG TASKS #########

task :new do
  if ARGV.length == 0
    title = "new-article"
  else
    title = ARGV.join("-")
  end
  filename = "#{Date.today.strftime('%Y%m%d')}-#{title}.md"
  ARGV.clear

  template = "title:
post_id:
slug: #{title}\n
#!!==========================================================\n\n"

  File.open("./articles/#{filename}", 'w') {|f| f.write(template) }
  %x{open -a "iA Writer" "./articles/#{filename}"}
  puts filename
end

task :coveralls do
 `bundle exec coveralls push`
end





######### CUCUMBER TASKS #########
require 'cucumber'
require 'cucumber/rake/task'
require 'yaml'

profiles = YAML::load(File.open(File.join(Dir.pwd, 'cucumber.yml')))

profiles.each do |name, value|
  desc "Run profile #{name}: #{value}"
  Cucumber::Rake::Task.new(name.to_sym, "Run profile #{name}: #{value}") do |t|
    t.profile = name
  end
end

Cucumber::Rake::Task.new(:creport, "Output an HTML report and rerun.txt file to reports/") do |t|
  t.profile = 'default'
  t.cucumber_opts = "--format html --out results/test_report_demo.html --format rerun --out results/rerun.txt"
end

Cucumber::Rake::Task.new(:cucumber, "Run all cucumber tests") do |t|
  t.profile = 'all'
end

Cucumber::Rake::Task.new(:crerun, "Rerun failed scenarios from 'report' rake task") do |t|
  t.profile = 'default'
  t.cucumber_opts = "@results/rerun.txt -r features"
end

Cucumber::Rake::Task.new(:t, "Run 'all' profile, pass tags as args.") do |t|
  t.profile = 'all'
  ARGV.shift #Ignore the first value in ARGV (it will be the rake task name)
  options = ""
  ARGV.each do |tag|
    options.concat("--tags #{tag} ") if tag.match(/^(?:@|~)/) #Only add arguments that begin with '@' or '~'.
  end
  t.cucumber_opts = options
end

######### OTHER TASKS #########

task :build do
  require 'jammit'
  Jammit.package!
end

task :update do
  puts "Updating Project..."
  puts `bundle update`
  puts `bundle exec bourbon update --path scss`
  puts `bower update`
end
