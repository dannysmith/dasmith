module DannyIs
  class ArticleImage
    attr_reader :filename, :order, :title

    # Expects a image_path, which should be the path to the file (an any format that includes
    #  the full pathname).
    def initialize(image_path)

      # Set up instance variables
      @filename = File.basename(image_path)
      path = File.basename(image_path, '.*')
      @order = path.split('-')[1].to_i
      @title = path.split('-')[2..-1].join(' ').gsub('_', ' ').capitalize
    end

    def url
      "/article-images/#{@filename}"
    end

    # Class method to load all images for a specific article.
    # Must be provided with an article_id and load_path.
    def self.load(params = {})
      raise ArgumentError, 'You must provide a ":loadpath" parameter' unless params[:load_path]
      raise ArgumentError, 'You must provide a ":article_id" parameter' unless params[:article_id]

      # Find the relevant article images and save them.
      images = Dir["#{File.dirname(__FILE__)}/#{params[:load_path]}/#{params[:article_id]}-*.{png,jpg,jpeg,gif,webp,svg}"]

      # Return an array of new image objects, sorted by their order attribute.
      images.map! {|image_path| self.new image_path}
      images.sort! { |a, b| a.order <=> b.order }
    end
  end
end
