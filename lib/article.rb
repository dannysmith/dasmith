require 'redcarpet'
require 'yaml'
require 'date'
require "pry"
require 'active_support/all' #TODO: Cherry-pick only the activesupport modules I need
require_relative './article_renderer'

class Article
  attr_reader :body_as_markdown,
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
   space_after_headers: true,
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

  # -------------------------- MAIN METHOD ------------------------ #

  def self.configure
    # Read config from block passed in and set class-level instance vars
    yield self if block_given?

    # Load Articles
    load_articles
    load_draft_articles if self.development_mode

    # Sort Articles by date DESC
    @@articles.sort! { |a, b| b.date <=> a.date }
  end



  # ----------------------- OTHER CLASS METHOD --------------------- #

  def self.first
    @@articles.first
  end

  def self.latest
    @@articles.first
  end

  def self.all(params = {})
    if params[:page]
      @@articles.in_groups_of(self.articles_per_page, false)[params[:page]-1]
    else
      @@articles
    end
  end

  def self.published(params = {})
    published_articles = @@articles.map { |article| article unless article.date > Date.today }
    if params[:page]
      published_articles.in_groups_of(self.articles_per_page, false)[params[:page]-1]
    else
      published_articles
    end
  end

  def self.pages
    @@articles.in_groups_of(self.articles_per_page, false)
  end

  def self.find(params = {})
    raise "must provide and id" unless params[:id]
    @@articles.each {|article| return article if article.article_id == params[:id]}
  end




  # -------------------------- INSTANCE METHODS ------------------------ #

  def initialize(file)
    @body_as_markdown = File.read(file)
    @date = extract_article_date(file)

    # Extract frontmatter
    frontmatter = extract_frontmatter_as_yaml(file, @body_as_markdown)
    @title = frontmatter[:title]
    @slug = "#{frontmatter[:slug]}-#{@date.strftime("%d%m%y")}"
    @article_id = frontmatter[:article_id].to_i

    # Read in Images
    @images = ArticleImage.load(load_path: self.class.images_path,
                                article_id: @article_id)

    # Render Markdown into HTML
    renderer = ArticleRenderer.new(@images, with_toc_data: false, prettify: true)
    parser = Redcarpet::Markdown.new(renderer, REDCARPET_OPTIONS)
    @body = parser.render(extract_mainmatter_as_markdown(file, @body_as_markdown))

    @@articles << self
  end

def next

end

def previous

end

def intro

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
