require 'redcarpet'

#################################################################################################
# Markdown Renderer
# -----------------
#   Parses the document looking for special tags. They must be paragraphs on their own to work.
#   Accepted Tags:
#
#     {{image: 1}}                                Renders the first image for this article.
#     {{gist:https://gist.github.com/user/123}}   Renders the Gist embed code for the Gist
#
#
#   For images to work, you must pass an array of hashes, each containing:
#     :post_id    Integer
#     :order      Integer
#     :title      String
#     :url        String
#################################################################################################
class ArticleRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  def initialize(images = [], options = {})
    super options
    @images = images
  end

  def block_code(code, language)
    require 'pygments'
    Pygments.highlight(code, lexer: language, options: { linespans: 'line' })
  end

  def paragraph(text)
    # Matches against the {{key:value}}. Key is tag[1], value is tag[2].
    tag = text.match(/^{{([^:]+):(.+)}}$/)
    if tag.nil?
      # Just render the usual text and add a &nbsp between the last two words
      "<p>#{text.reverse.split(' ', 2).join('&nbsp;'.reverse).reverse}</p>\n\n"
    else
      case tag[1]
      when 'gist'
        "<script src=\"#{tag[2]}.js\"></script>"
      when 'image'
        begin
          # Build the image embed code
          # Check in images to see if they exist, if so add the url and alt text from the hash.
          image = @images[tag[2].to_i]

          "<figure class=\"article-image\">
              <a href=\"/article-images/#{image[:url]}\">
                <img src=\"/article-images/#{image[:url]}\" alt=\"#{image[:title]}\" />
              </a>
            <figcaption>#{image[:title]}</figcaption>
          </figure>"
        rescue Exception => e
          "<p style='color: red; background: yellow; font-weight: bold;'>#{text} (malformed image tag, or image does not exist: #{e.message})</p>"
        end
      when 'imageraw'
        begin
          image = @images[tag[2].to_i]
          "<img src=\"/article-images/#{image[:url]}\" alt=\"#{image[:title]}\" />"
        rescue Exception => e
          "<p style='color: red; background: yellow; font-weight: bold;'>#{text} (malformed imageraw tag, or image does not exist: #{e.message})</p>"
        end
      end
    end
  end

  # Prevent Bold, Emphasised or Linked text breaking if it's short.
  def emphasis(text)
    "<em>#{do_not_break_string text}</em>"
  end

  def double_emphasis(text)
    "<strong>#{do_not_break_string text}</strong>"
  end

  def link(link, title, content)
    "<a href=\"#{link}\" title=\"#{title}\">#{do_not_break_string content}</a>"
  end

  def list_item(text, _list_type)
    "<li><span>#{text}</span></li>\n"
  end

  def table(header, body)
    "<div class=\"table-wrapper\">
       <table>#{header}#{body}</table>
     </div>"
  end

  def normal_text(text)
    "#{process_text text}"
  end

  private

  # Replace spaces with nbsps if tring has less than the required number of words
  def do_not_break_string(min_words = 4, text)
    text = text.split.join('&nbsp;') if text.split.size <= min_words
    text
  end

  # Add &nbsp; to paragraph to meet the following rules:
  # 1. Never break after a preposition
  # 2. Never break after a dash
  # 3. Never break after a short word
  def process_text(text)
    regexp = /(?:\s|^|>)(?<word>(\w{0,3}|[-–—]|\&ndash\;|\&mdash\;|aboard|about|above|across|after|against|along|amid|among|anti|around|before|behind|below|beneath|beside|besides|between|beyond|concerning|considering|despite|down|during|except|excepting|excluding|following|from|inside|into|like|minus|near|onto|opposite|outside|over|past|plus|regarding|round|save|since|than|that|this|through|toward|towards|under|underneath|unlike|until|upon|versus|with|within|without)(?<space>\s))/i
    text.gsub(regexp).each { |m| "#{m[0..-2]}&nbsp;" }
  end
end
