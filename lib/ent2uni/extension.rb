require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'htmlentities'

include ::Asciidoctor

# Replaces HTML entities by their unicode equivalents
#
# @author James Carlson

class EntToUni < Extensions::Postprocessor

  def process document, output
    decoder = HTMLEntities.new  
    output = decoder.decode output
  end
  
end
