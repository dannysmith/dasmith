require 'redcarpet'
require 'yaml'
require 'date'
require_relative './article_renderer'

# Article Class Handles loading an Article
# Expects a file path as a string and an array of all image paths.
class Article
  attr_accessor :title, :slug, :body, :body_as_markdown, :publish_date, :post_id, :images

  def initialize(file, images)

    # Parse the file to seperate out the markdown and parse the Yaml.
    @body_as_markdown = File.read(file)
    data = @body_as_markdown.split(/#!!====+/, 2)
    meta = YAML.load(data[0])
    date = File.basename(file).split('-')[0]

    # Set the date attribute
    if date.match /[0-9]{8}/
      year = date[0..3].to_i
      month = date[4..5].to_i
      day = date[6..8].to_i
      @publish_date = DateTime.new(year, month, day)
    else
      raise "#{File.basename(file)} is in the wrong format. There is no date in the filename."
    end

    # Set the other attributes
    if meta['title'].nil? || meta['slug'].nil?
      raise "#{File.basename(file)} is in the wrong format. This is no correct title and slug data"
    else
      @title = meta['title']
      @slug = "#{meta['slug']}-#{date[2..8]}"
      @post_id = meta['post_id'].to_i
    end

    # Insert the images, if present.
    @images = {}

    images.each do |filename|
      filename = File.basename(filename)
      img = filename.split('.')[0]

      # If the image is for this post, make a hash and put it in @images.
      if img.split('-')[0].to_i == @post_id

        image_title = img.split('-')[2..img.length].join(' ')

        hash = { img.split('-')[1].to_i => { title: image_title, url: filename } }

        @images.merge!(hash)
      end
    end

    # Set up Renderer
    renderer = ArticleRenderer.new(@images, with_toc_data: true, prettify: true)
    markdown = Redcarpet::Markdown.new(renderer,
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
                                       footnotes: true)

    # Parse the Markdown and set the body attribute
    @body = markdown.render(data[1])
  end

end
