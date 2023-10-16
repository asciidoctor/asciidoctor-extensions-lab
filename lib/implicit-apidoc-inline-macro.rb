# An inline macro that turns Java types the begin with java. or javax. into links.
#
# Usage
# 
#   Implement the javax.validation.Validator interface.
#
# @author Aslak Knutsen
Asciidoctor::Extensions.register do
  inline_macro do
    named :apidoc
    match /((?:java|javax)\.\w[\.\w]+\.[A-Z]\w+)/
    process do |parent, target|
      doc_uri_pattern = 'https://javaee-spec.java.net/nonav/javadocs/%s.html'
      doc_uri = doc_uri_pattern % (target.gsub %r/\./, '/')
      link_name = target
      if /([A-Z]\w*$)/ =~ target
        link_name = $1
      end
      create_anchor parent, link_name, type: :link, target: doc_uri, attributes: { 'title' => target }
    end
  end
end
