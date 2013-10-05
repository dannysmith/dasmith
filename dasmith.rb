# DASmith main Application class.
class DASmith < Sinatra::Base

  $articles = []
  ARTICLE_PAGE_LIMIT = 5
  $page_count = 0

  configure :development do
    require 'better_errors'
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  configure do

    # Pull all of the articl-images into @images array
    @images = []
    Dir[File.dirname(__FILE__) + '/public/article-images/*.{png,jpg,jpeg,gif,webp,svg}'].each { |img| @images << img }

    # Pull in the markdown files and put them in the $articles array.
    puts 'Loading Articles...'
    Dir[File.dirname(__FILE__) + '/articles/*.md'].each do |f|
      article = Article.new(f, @images)
      puts File.basename f
      $articles << article unless article.publish_date > Date.today
    end

    $articles.sort! { |a, b| a.publish_date <=> b.publish_date }
    $articles.reverse!

    $page_count = ($articles.size.to_f / ARTICLE_PAGE_LIMIT.to_f).ceil
  end

  get '/' do
    @articles = $articles[0..(ARTICLE_PAGE_LIMIT-1)]
    erb :index
  end

  get '/about/?' do
    erb :about
  end

  get '/articles/?' do
    @articles = $articles
    erb :article_list
  end

  get %r{/articles/([0-9]+)/?} do
    @page = params[:captures].first.to_i
    a = (@page - 1) * ARTICLE_PAGE_LIMIT

    @articles = $articles[a..(a + ARTICLE_PAGE_LIMIT - 1)]

    if @articles.nil?
      # There are no articles for that page
      status 404
    else
      erb :articles
    end
  end

  get '/articles/:slug/?' do
    $articles.each do |a|
      @article = a if a.slug == params[:slug]
    end

    if @article
      erb :article
    else
      status 404
    end
  end

end
