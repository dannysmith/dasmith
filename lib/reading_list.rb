module DannyIs
  module ReadingList
    require 'readit'

    def self.load(service = :all)
      if service == :readability
        Loader.load_readability_notes.compact
      elsif service == :pocket
        Loader.load_pocket_notes.compact
      elsif service == :all
        notes = Loader.load_readability_notes
        notes << Loader.load_pocket_notes
        #Now sort by date
        notes.compact
      end
    end

    class Item
      attr_accessor :title, :image, :url, :excerpt, :service, :date, :word_count
      def initialize(params = {})
        @title = params[:title]
        @image = params[:image]
        @url = params[:url]
        @excerpt = params[:excerpt] || ''
        @service = params[:service] || :unknown
        @date = params[:date]
        @word_count = params[:word_count]
      end
    end

    class Loader
      def self.load_readability_notes
        @consumer = OAuth::Consumer.new(ENV['READABILITY_KEY'], ENV['READABILITY_SECRET'],
                                            site: 'https://www.readability.com/',
                                            access_token_path: '/api/rest/v1/oauth/access_token/')

        @access_token = @consumer.get_access_token(nil, {}, x_auth_mode: 'client_auth',
                                                            x_auth_username: ENV['READABILITY_KEY'],
                                                            x_auth_password: ENV['READABILITY_PASSWORD'])

        Readit::Config.consumer_key = ENV['READABILITY_KEY']
        Readit::Config.consumer_secret = ENV['READABILITY_SECRET']
        Readit::Config.parser_token = ENV['READABILITY_PARSER_TOKEN']

        @api = Readit::API.new @access_token.token, @access_token.secret
        @bookmarks, @metadata = @api.bookmarks(archive: 1, per_page: 50, include_meta: true)

        items = []
        @bookmarks.each do |bookmark|
          items << Item.new(title: bookmark.article.title,
                            image: bookmark.article.lead_image_url,
                            url: bookmark.article.url,
                            excerpt: bookmark.article.excerpt,
                            service: :readability,
                            date: DateTime.parse(bookmark.date_archived),
                            word_count: bookmark.article.word_count
                            )
        end
        items
      end


      def self.load_pocket_notes

      end
    end
  end
end
