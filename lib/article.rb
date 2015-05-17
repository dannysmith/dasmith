module DannyIs
  class Article
    attr_reader :body_as_markdown,
                :body,
                :date,
                :title,
                :slug,
                :article_id,
                :images

    # Class-level instance variables to store settings
    class << self
      attr_accessor :articles_path,
                    :images_path,
                    :articles_per_page,
                    :development_mode,
                    :draft_articles_path
    end

    # Hold all our articles, once they've been read in.
    @@articles = []

    REDCARPET_OPTIONS = {
     autolink: false,
     prettify: true,
     no_intra_emphasis: true,
     fenced_code_blocks: true,
     disable_indented_code_blocks: false,
     strikethrough: true,
     space_after_headers: true,
     superscript: true,
     underline: true,
     highlight: true,
     tables: true,
     quote: false,
     footnotes: true
    }

    # -------------------------- CLASS METHODS ------------------------ #

    def self.configure
      # Read config from block passed in and set class-level instance vars
      yield self if block_given?

      # Load Articles
      load_articles
      load_draft_articles if self.development_mode
      # Sort Articles by date DESC
      @@articles.sort! { |a, b| b.date <=> a.date }
    end




    def self.latest
      @@articles.first
    end

    def self.all(params = {})

      # Remove any future-dated posts if this flag is passed.
      if params[:published_only]
        articles = @@articles.delete_if { |article| article.date > Date.today }
      else
        articles = @@articles
      end

      if params[:page]
        page = articles.in_groups_of(self.articles_per_page)[params[:page].to_i-1]
        if page.nil?
          []
        else
          page.compact
        end
      else
        articles
      end
    end

    def self.published(params = {})
      self.all(params.merge(published_only: true))
    end

    def self.pages(params = {})
      self.published(params.except(:page)).in_groups_of(self.articles_per_page).compact.map!(&:compact)
    end

    def self.find(params = {})
      if params[:id]
        @@articles.select {|article| article.article_id == params[:id]}.first
      elsif params[:slug]
        @@articles.select {|article| article.slug == params[:slug]}.first
      else
        nil
      end
    end

    def self.newer_article(article)
      new_article_location = self.published.index(article) - 1
      if new_article_location < 0
        nil
      else
        self.published[new_article_location]
      end
    end

    def self.older_article(article)
      new_article_location = self.published.index(article) + 1
      if new_article_location > self.published.size - 1
        nil
      else
        self.published[new_article_location]
      end
    end

    # Optionally recieves:
    # :limit - how many articles you want returned
    # :exclude - an article or array of articles that you don't want included.
    def self.featured(params ={})
      params[:limit] ||= 4
      if params[:exclude].respond_to? :each
        pool = self.published - params[:exclude]
      else
        pool = self.published - [params[:exclude]]
      end
      pool.sample params[:limit]
    end


    # -------------------------- INSTANCE METHODS ------------------------ #

    def initialize(file, image_class = ArticleImage, article_renderer = ArticleRenderer)
      @body_as_markdown = File.read(file)
      @date = extract_article_date(file)

      # Extract frontmatter
      frontmatter = extract_frontmatter_as_yaml(file, @body_as_markdown)
      @title = frontmatter[:title]
      @slug = "#{frontmatter[:slug]}-#{@date.strftime("%y%m%d")}"
      @article_id = frontmatter[:article_id].to_i

      # Read in Images
      @images = image_class.load(load_path: self.class.images_path,
                                  article_id: @article_id)

      # Render Markdown into HTML
      renderer = article_renderer.new(@images, with_toc_data: false, prettify: true)
      parser = Redcarpet::Markdown.new(renderer, REDCARPET_OPTIONS)
      @body = parser.render(extract_mainmatter_as_markdown(file, @body_as_markdown))

      @@articles << self
    end

  def newer
    self.class.newer_article(self)
  end

  def older
    self.class.older_article(self)
  end

  def intro(params = {})
    params.reverse_merge!({characters: 500})

    # Select only lines beginning with <p>.
    paragraphs = @body.split("\n").select {|line| line.match /^<p>/ }

    # Keep full paragraphs up to the nearest 200 characters.
    i = 0
    paragraphs.map! do |para|
      i += para.size
      para if i < params[:characters]
    end
    paragraphs.join("\n")
  end

  def url
    "#{ENV['BASE_DOMAIN']}/writing/#{self.slug}"
  end


    # -------------------------- PRIVATE METHODS ------------------------ #

    private

    def self.load_articles
      puts "Loading articles from #{self.articles_path}..."

      Dir[File.dirname(__FILE__) + '/' + self.articles_path + '/*.md'].each do |file|
        self.new file
        puts File.basename file
      end
    end

    def self.load_draft_articles
      puts "Loading draft articles from #{self.draft_articles_path}..."

      Dir[File.dirname(__FILE__) + '/' + self.draft_articles_path + '/*.md'].each do |file|
        self.new file
        puts File.basename "#{file} (Draft)"
      end
    end

    def extract_article_date(file)
      date = File.basename(file).split('-')[0]

      if date.match(/[0-9]{8}/)
        year = date[0..3].to_i
        month = date[4..5].to_i
        day = date[6..8].to_i

        return DateTime.new(year, month, day)
      else
        fail "#{File.basename(file)} is in the wrong format. There is no date in the filename."
      end
    end

    # Expects a markdown file in the correct markdown format. Although it is acceptable
    #  to pass just a file object, if you have already read the file, you can optionally
    #  pass in the raw markdown as a second argument. This saves reading the file again.
    def extract_frontmatter_as_yaml(file, markdown = nil)

      markdown ||= File.read(file)

      begin
        frontmatter = YAML.load(markdown.split(/#!!====+/, 2)[0]).symbolize_keys

        # Check the title, slug and post ID have been included
        if (frontmatter[:title] && frontmatter[:slug] && frontmatter[:article_id])
          return frontmatter
        else
          fail "It looks like the frontmatter in #{file} is incomplete. article_id, slug or title is missing or malformed."
        end
      rescue TypeError, Psych::SyntaxError => e
        fail "The YAML frontmatter in #{file} looks to be malformed: #{e}."
      end
    end

    # Expects a markdown file in the correct markdown format. Although it is acceptable
    #  to pass just a file object, if you have already read the file, you can optionally
    #  pass in the raw markdown as a second argument. This saves reading the file again.
    def extract_mainmatter_as_markdown(file, markdown = nil)
      markdown ||= File.read(file)

      begin
        markdown.split(/#!!====+/, 2)[1]
      rescue TypeError => e
        fail "The YAML mainmatter in #{file} looks to be malformed: #{e}."
      end
    end

  end
end
