require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# A block that demonstrates how to introduce a new section into the document.
# The block must be used in a valid location for a section (meaning it cannot
# be inside another block).
Extensions.register do
  block do
    named :gherkin
    on_context :literal
    parse_content_as :raw
    process do |parent, reader, attrs|
      sect = Section.new parent, 1, (parent.document.attr 'sectnums')
      sect.title = 'Foobar'
      sect.id = 'foobar'
  
      sect << (create_paragraph parent, reader.lines, attrs)
      parent << sect
      nil
    end
  end
end
