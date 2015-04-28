# DASmith main Application class.
class DASmith < Sinatra::Base
  use Rack::MethodOverride ## <-- Required for put delete etc
  helpers Sinatra::ContentFor

  # -------------------------- CONFIG ------------------------ #

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

    # Set up Readit config
    Readit::Config.consumer_key = ENV['READABILITY_KEY']
    Readit::Config.consumer_secret = ENV['READABILITY_SECRET']
    Readit::Config.parser_token = ENV['READABILITY_PARSER_TOKEN']

    # Read in Articles
    Article.configure do |config|
      config.articles_path = 'articles'
      config.draft_articles_path = 'articles/drafts'
      config.images_path = 'public/article-images'
      config.articles_per_page = 3
      config.development_mode = true if ENV['RACK_ENV'] == 'development'
    end
  end

  # -------------------------- HOOKS------------------------ #


  before do

    @logo_path = "/images/logo#{rand(1..6)}.png"

    # Switch on Caching
    cache_control :public, :must_revalidate, max_age: 60
  end








  # -------------------------- Web Routes ------------------------ #

  get '/' do
    redirect '/writing'
  end

  get '/writing' do
    @articles = [Article.latest]
    @more_articles = Article.published
    @logo_path = '/images/logo1.png'
    erb :index
  end

  get '/about/?' do
    erb :about
  end

  get '/writing/articles/?' do
    @articles = Article.published
    erb :article_list
  end

  get %r{/writing/articles/([0-9]+)/?} do
    @page = params[:captures].first.to_i
    @articles = Article.published(page: page)

    @more_articles = Article.published

    if @articles.nil?
      # There are no articles for that page
      status 404
    else
      erb :articles
    end
  end

  get '/writing/:slug/?' do
    @more_articles = []
    Article.published.each do |a|
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



  # -------------------------- Readability ------------------------ #

  get '/reading' do

    @consumer = OAuth::Consumer.new(ENV['READABILITY_KEY'], ENV['READABILITY_SECRET'],
                                    site: 'https://www.readability.com/',
                                    access_token_path: '/api/rest/v1/oauth/access_token/')

    @access_token = @consumer.get_access_token(nil, {}, x_auth_mode: 'client_auth',
                                                        x_auth_username: ENV['READABILITY_KEY'],
                                                        x_auth_password: ENV['READABILITY_PASSWORD'])

    @api = Readit::API.new @access_token.token, @access_token.secret

    @bookmarks, @meta = @api.bookmarks(archive: 1, per_page: 50, include_meta: true)

    erb :reading
  end


  ###################### EVERNOTE AGILE NOTES ############

  get '/agile/?' do
    # NOTE: TOKEN WILL EXPIRE ON 22 DEC 2015.
    # You can Renew it Here: https://dev.evernote.com/doc/articles/authentication.php#devtoken
    if Date.today > Date.parse('2015-12-22')
      "Ooops. It seems my Evernote API key has Expired. Could you tweet @dannysmith and let me know. Muchas gracias!"
    else
      @notes = get_evernote_notes 'notebook:"Agile Toolkit" tag:"published"'
      erb :agile
    end
  end


  ###################### EVERNOTE LINKS ############

  get '/noting/?' do
    if Date.today > Date.parse('2015-12-22')
      "Ooops. It seems my Evernote API key has Expired. Could you tweet @dannysmith and let me know. Muchas gracias!"
    else
      @links = get_evernote_notes 'notebook:"danny.is Links"'
      erb :links
    end
  end




  ##################### JSON ROUTES #####################

  get '/articles.json' do
    binding.pry
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




  private

  def get_evernote_notes(filter)
    client = EvernoteOAuth::Client.new(
      token: ENV['EVERNOTE_DEV_TOKEN'],
      sandbox: false
    )
    note_store = client.note_store

    # Create Filters
    ev_filter = Evernote::EDAM::NoteStore::NoteFilter.new
    ev_filter.words = filter

    # Get Notes
    notes_list = note_store.findNotes(ev_filter, 0, 1000)
    notes = []

    notes_list.notes.each do |note|
      notes << {
        title: note.title,
        content: note_store.getNoteContent(note.guid),
        url: note.attributes.sourceURL
      }
    end
    return notes.reverse
  end


end
