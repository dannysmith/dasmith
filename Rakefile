# Rakefile

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

  File.open("./articles/#{filename}", 'w') { |f| f.write(template) }
  puts filename
  `vim ./articles/#{filename}`
end

task :build do
  require 'jammit'
  Jammit.package!
end

task :update do
  puts 'Updating Project...'
  puts `bundle update`
  puts `bundle exec bourbon update --path scss`
  puts `bower update`
end
