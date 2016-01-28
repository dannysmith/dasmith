module DannyIs
  class ArticleRenderer < ::Redcarpet::Render::HTML
    require 'rouge'

    include ::Redcarpet::Render::SmartyPants

    def initialize(images = [], options = {})
      @images = images
      super options
    end

    def block_code(code, language)
      require 'pygments'
      Pygments.highlight(code, lexer: language, options: { linespans: 'line', cssclass: "highlight highlight-#{language}" })
    rescue MentosError => e
      if e.message.include? 'ClassNotFound: no lexer'
         # If we recieve a Python-generated error message for no lexer, just use text.
        Pygments.highlight(code, lexer: 'text', options: { linespans: 'line', cssclass: "highlight highlight-#{language} highlight-unknown" })
      else
        raise e
      end
    end

    # Wrap tables in a containing div.
    def table(header, body)
      "<div class=\"table-wrapper\">
  <table>
#{header}#{body}
  </table>
</div>\n"
    end

    # Prevent emphasized text from breaking
    def emphasis(text)
      "<em>#{do_not_break_string(text)}</em>"
    end

    # Prevent strong text from breaking
    def double_emphasis(text)
      "<strong>#{do_not_break_string(text)}</strong>"
    end

    # Prevent links from breaking
    def link(link, _title, content)
      "<a href=\"#{link}\">#{do_not_break_string(content)}</a>"
    end

    # Never break after prepositions, dashes or short words
    # def normal_text(text)
    #   "#{add_non_breaking_spaces_to_normal_text(text)}"
    # end

    def block_quote(quote)
      matches = quote.split("--").map(&:strip)

      if matches[1]
        footer = "<footer class=\"c-blockquote__footer o-pull-block__footer\">
  <span>#{matches[1].gsub('</p>','')}</span>
  </footer>"
      end

      "<blockquote class=\"c-blockquote o-pull-block o-pull-block--left\">
  <div class=\"c-blockquote__content o-pull-block__content\">
    #{matches[0] + "</p>"}
  </div>
  #{footer unless footer.nil?}
</blockquote>\n"
    end

    def paragraph(text)
      # Matches against the {{key:value}}. Key is tag[1], value is tag[2].
      tag = text.match(/^{{([^:]+):(.+)}}$/)
      aside = text.match(/^aside&gt;(.+)/)

      if aside
        "<aside class=\"c-aside\"><i class=\"u-icon u-icon-tags u-icon-2x pull-left\"></i> #{aside[1].strip}</aside>\n\n"
      elsif tag.nil?
        adjusted_text = add_non_breaking_spaces_to_normal_text(text)
        # Just render the usual text and add a &nbsp between the last two words
        "<p>#{adjusted_text.reverse.split(' ', 2).join('&nbsp;'.reverse).reverse}</p>\n\n"
      else

        # More meaningful names
        tag_type = tag[1]
        tag_data = tag[2]


        case tag_type

        # Handle the auto-insertion of Gists
        when 'gist'
          "<script src=\"#{tag_data.strip}.js\"></script>"


        # Handle the auto-insertion of Images
        when 'image'
          begin
            image = @images[tag_data.to_i - 1]

            "<figure class=\"o-pull-block o-pull-block--left c-image-figure\">
  <a class=\"o-pull-block__content\" href=\"#{image.url}\">
    <img src=\"#{image.url}\" alt=\"#{image.title}\" />
  </a>
  <figcaption class=\"o-pull-block__footer\">#{image.title}</figcaption>
</figure>\n\n"
          rescue Exception => e
            warn "!!!!!!! Malformed image tag for #{image}: #{e}"
            "<!-- Malformed image tag for #{image}-->"
          end
        when 'imageraw'
          begin
            image = @images[tag_data.to_i - 1]
            "<img src=\"#{image.url}\" alt=\"#{image.title}\" />\n"
          rescue Exception => e
            warn "!!!!!!! Malformed image tag for #{image}: #{e}"
            "<!-- Malformed image tag for #{image}-->"
          end
        end
      end
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
    def add_non_breaking_spaces_to_normal_text(text)
      regexp = /(?:\s|^|>)(?<word>(\w{0,3}|[-–—]{1,4}|\&ndash\;|\&mdash\;|aboard|about|above|across|after|against|along|amid|among|anti|around|before|behind|below|beneath|beside|besides|between|beyond|concerning|considering|despite|down|during|except|excepting|excluding|following|from|inside|into|like|minus|near|onto|opposite|outside|over|past|plus|regarding|round|save|since|than|that|this|through|toward|towards|under|underneath|unlike|until|upon|versus|with|within|without)(?<space>\s))/i
      text.gsub(regexp).each { |m| "#{m[0..-2]}&nbsp;" }
    end
  end
end
