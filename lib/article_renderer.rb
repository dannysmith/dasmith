#################################################################################################
# Markdown Renderer
# -----------------
#   Parses the document looking for special tags. They must be paragraphs on their own to work.
#   Accepted Tags:
#
#     {{image: 1}}																Renders the first image for this article.
#     {{gist:https://gist.github.com/user/123}}   Renders the Gist embed code for the Gist
#
#
#   For images to work, you must pass an array of hashes, each containing:
#     :post_id    Integer
#     :order			Integer
#     :title      String
#     :url        String
#################################################################################################
require 'redcarpet'

class ArticleRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants

  def initialize(images = [], options = {})
    super options
    @images = images
  end

  def block_code(code, language)
    require 'pygments'
    Pygments.highlight(code, :lexer => language, options: {linespans: 'line'})
  end

  def paragraph(text)
    # Matches against the {{key:value}}. Key is tag[1], value is tag[2].
    tag = text.match(/^{{([^:]+):(.+)}}$/)
    if tag.nil?
      "<p>#{text}</p>" # Just render the usual text
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

  def list_item(text, list_type)
    "<li><span>#{text}</span></li>"
  end

  def table(header, body)
    "<div class=\"table-wrapper\">
       <table>#{header}#{body}</table>
     </div>"
  end
end

