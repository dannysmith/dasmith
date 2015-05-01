require 'yaml'
require 'redcarpet'
require 'active_support/all'
#TODO: Cherry-pick only the activesupport modules I need

module DannyIs
  class App < Sinatra::Base
    use Rack::MethodOverride # <-- Required for put delete etc
    helpers Sinatra::ContentFor

    # -------------------------- CONFIG ------------------------- #

    configure :development do
      require 'better_errors'
      use BetterErrors::Middleware
      BetterErrors.application_root = __dir__
    end

    configure :production do
      require 'newrelic_rpm'
    end

    configure do
      Article.configure do |config|
        config.articles_path = '../articles'
        config.draft_articles_path = '../articles/drafts'
        config.images_path = '../public/article-images'
        config.articles_per_page = 2
        config.development_mode = true if ENV['RACK_ENV'] == 'development'
      end
    end

    before do
      @logo_path = '/images/logo1.png'
      # @logo_path = "/images/logo#{rand(1..6)}.png" # Display a random photo
      cache_control :public, :must_revalidate, max_age: 60 # Switch on Caching
    end


    # -------------------------- Web Routes ------------------------ #

    get '/' do
      redirect '/writing'
    end

    get '/writing/?' do
      @articles = [Article.latest]
      erb :index
    end

    get '/about/?' do
      erb :about
    end

    get '/reading/?' do
      @bookmarks = DannyIs::ReadingList.load
      erb :reading
    end

    get '/noting/?' do
      @links = DannyIs::Evernote.notes('danny.is Links')
      erb :links
    end

    get '/writing/articles/?' do
      @articles = Article.published
      erb :article_list
    end

    get %r{/writing/page/([0-9]+)/?} do
      page = params[:captures].first.to_i
      @articles = Article.published page: page

      @more_articles = Article.featured limit: 4,
                                        exclude: @articles

      if @articles.nil? || @articles.empty?
        status 404
      else
        erb :articles_page
      end
    end

    get '/writing/:slug/?' do
      @article = Article.find slug: params[:slug]

      @more_articles = Article.featured limit: 4,
                                        exclude: @article

      if @article
        erb :article
      else
        status 404
      end
    end


    # -------------------------- RSS Feeds ------------------------ #

    get '/feed/?' do
      @articles = Article.published
      builder :feed
    end

    # -------------------------- JSON Routes ------------------------ #

    # get '/articles.json' do
    # end

    # get '/articles/:post.json' do
    # end

    # -------------------------- Redirects ------------------------ #

    get // do
      path = request.path_info
      case path
      when %r{^/cv(?:/|\.pdf)?$}
        redirect 'http://files.dasmith.co.uk/cv.pdf', 301
      when /^\/files(.*)/
        redirect "http://files.dasmith.co.uk/files#{$1}", 301
      else
        status 404
        erb :page404
      end
    end
  end
end


