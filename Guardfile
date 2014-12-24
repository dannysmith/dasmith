# # Guardfile
notification :growl

guard :foreman, port: 3001 do
  watch('Gemfile.lock')
  watch %r{^(lib|models)/.*\.rb}
  watch %r{^articles/.*\.md}
  watch 'config.ru'
  watch 'dasmith.rb'
end

# Restart the bundles if I change the Gemfile
guard :bundler do
  watch('Gemfile')
end

# Rebuild the css when any SASS files are changed.
guard :sass, input: 'scss', output: 'public/css', style: 'expanded', all_on_start: true

# Concatinate JS using Jammit (could use for CSS too).
guard :jammit,
  config_path: 'assets.yml',
  output_folder: './public',
  package_on_start: true do
    watch %r{javascripts/.+\.js$}
    watch 'public/css/main.css'
    watch 'assets.yml'
end

# Reload the browser on changes to CSS, ERB or HTML.
guard :livereload do
  watch %r{views/.+\.(erb|haml)$}
  watch %r{public/.+\.(css|js|html)}
  watch %r{scss/.+\.(css|scss|sass)}
end

# guard :migrate do
#   watch(%r{^db/migrate/(\d+).+\.rb})
#   watch('db/seeds.rb')
# end
