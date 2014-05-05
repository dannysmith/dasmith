# DASmith main Application class.
class DASmith < Sinatra::Base
  use Rack::MethodOverride ##<-- Required for put delete etc
  helpers Sinatra::ContentFor

  $articles = []
  $page_count = 0

  configure :development do
    require 'better_errors'
    require './development-envs'

    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure :production do
    require 'newrelic_rpm'
  end

  configure do

    # Pull all of the article-images into @images array
    @images = []
    Dir[File.dirname(__FILE__) + '/public/article-images/*.{png,jpg,jpeg,gif,webp,svg}'].each { |img| @images << img }

    # Pull in the markdown files and put them in the $articles array.
    puts 'Loading Articles...'
    Dir[File.dirname(__FILE__) + '/articles/*.md'].each do |f|
      article = Article.new(f, @images)
      puts File.basename f
      $articles << article
    end

    $articles.sort! { |a, b| a.publish_date <=> b.publish_date }
    $articles.reverse!

    Readit::Config.consumer_key = ENV['READABILITY_KEY']
    Readit::Config.consumer_secret = ENV['READABILITY_SECRET']
    Readit::Config.parser_token = ENV['READABILITY_PARSER_TOKEN']
  end





  before do
    # Put only the published articles in an array.
    @published_articles = []
    $articles.each do |article|
      @published_articles << article unless article.publish_date > Date.today
    end
    @page_count = (@published_articles.size.to_f / ENV['ARTICLE_PAGE_LIMIT'].to_f).ceil

    @logo_path = "/images/logo#{rand(1..6)}.png"
  end

  ##################### WEB ROUTES #####################

  get '/' do
    redirect '/writing'
  end

  get '/writing' do
    @articles = @published_articles[0..(ENV['ARTICLE_PAGE_LIMIT'].to_i - 1)]
    @more_articles = @published_articles[ENV['ARTICLE_PAGE_LIMIT'].to_i..-1]
    @logo_path = "/images/logo1.png"
    erb :index
  end

  get '/about/?' do
    erb :about
  end

  get '/writing/articles/?' do
    @articles = @published_articles
    erb :article_list
  end

  get %r{/writing/articles/([0-9]+)/?} do
    @page = params[:captures].first.to_i
    a = (@page - 1) * ENV['ARTICLE_PAGE_LIMIT'].to_i

    @articles = @published_articles[a..(a + ENV['ARTICLE_PAGE_LIMIT'].to_i - 1)]
    @more_articles = @published_articles[ENV['ARTICLE_PAGE_LIMIT'].to_i..-1]

    if @articles.nil?
      # There are no articles for that page
      status 404
    else
      erb :articles
    end
  end

  get '/writing/:slug/?' do
    @more_articles = []
    @published_articles.each do |a|
      if a.slug == params[:slug]
        @article = a
      else
        @more_articles << a
      end
    end

    if @article
      erb :article
    else
      status 404
    end
  end


  get '/reading' do

    @consumer = OAuth::Consumer.new(ENV['READABILITY_KEY'], ENV['READABILITY_SECRET'],
                                    :site=>"https://www.readability.com/",
                                    :access_token_path => "/api/rest/v1/oauth/access_token/")

    @access_token = @consumer.get_access_token(nil, {}, {:x_auth_mode => 'client_auth',
                                                         :x_auth_username => ENV['READABILITY_KEY'],
                                                         :x_auth_password => ENV['READABILITY_PASSWORD'] })

    @api = Readit::API.new @access_token.token, @access_token.secret

    @bookmarks, @meta = @api.bookmarks(archive: 1, per_page: 50, include_meta: true)

    erb :reading, layout: :layout_dark
  end


  ##################### JSON ROUTES #####################

  get '/articles.json' do

  end

  get '/articles/list.json' do

  end

  get '/articles/:post.json' do

  end

  ##################### RSS ROUTES #####################

  get '/feed/?' do
    @articles = @published_articles
    builder :feed
  end

  ##################### OTHER ROUTES #####################

  # Catch Other paths, or return a 404.
  get // do
    path = request.path_info
    case path
    when %r{^/cv(?:/|\.pdf)?$}
      redirect 'http://files.dasmith.co.uk/cv.pdf', 301
    when /^\/avatar(.*)/
      redirect "http://files.dasmith.co.uk/avatar#{$1}", 301
    when /^\/files(.*)/
      redirect "http://files.dasmith.co.uk/files#{$1}", 301
    else
      status 404
      erb :page404
    end
  end

  not_found do
    status 404
    erb :page404
  end
end
