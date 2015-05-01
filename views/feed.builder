xml.instruct! :xml, :version => '1.0'
xml.feed('xml:lang' => 'en-US', 'xmlns' => 'http://www.w3.org/2005/Atom') do
  xml.id "tag:#{ENV['BASE_DOMAIN']},2013:/feed"
  xml.title 'danny.is'
  xml.link(rel: 'alternate', type: 'text/html', href: "http://#{ENV['BASE_DOMAIN']}")
  xml.link(rel: 'self', type: 'application/atom+xml', href: "http://#{ENV['BASE_DOMAIN']}/feed")
  xml.updated DannyIs::Article.latest && DannyIs::Article.latest.date.xmlschema

  @articles.each do |article|
    xml.entry do
      xml.id "tag:#{ENV['BASE_DOMAIN']},2013:Post/#{article.slug}"
      xml.title article.title
      xml.link rel: 'alternate', type: 'text/html', href: "http://#{ENV['BASE_DOMAIN']}/#{article.slug}"
      xml.published article.date.xmlschema
      xml.updated article.date.xmlschema
      xml.author do
        xml.name "Danny Smith"
      end
      xml.content article.body
    end
  end
end
