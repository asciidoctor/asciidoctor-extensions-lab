require 'asciidoctor'
require 'asciidoctor/extensions'
require_relative 'xml_entity_mapper'

include ::Asciidoctor

# Converts named entities to character entities so they can be resolved without
# the use of external entity declarations. Primarily used for HTML documents.
#
# AsciiDoc documents often use named entities. However, XML defines only five
# named entities.
#
# This postprocessor reencodes most of the HTML 5 named entities into decimal
# entities so that they are valid in XML, HTML 4, and HTML 5. `&apos;` is not
# reencoded since named version is easier to read.
#
# @author Brian M. Carlson, Dan Allen
class XmlEntityPostprocessor < Extensions::Postprocessor
  NamedEntityRx = /&[A-Za-z]+[1-8]*;/

  def process document, output
    output.gsub(NamedEntityRx) { XmlEntityMapper.named_to_decimal $& }
  end
end