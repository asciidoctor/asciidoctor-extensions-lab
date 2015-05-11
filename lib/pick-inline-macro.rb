require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
include ::Asciidoctor

# An inline macro that picks text based on the presence of document-level attributes.
#
# Usage
#
#   pick:[target-web=Web,target-desktop=Desktop]
#   pick:[target-web.target-mobile=Web,target-desktop=Desktop]
#
Extensions.register do
  inline_macro do
    named :pick
    # FIXME `using_format :short` not working, ordering issue
    match resolve_regexp @name, :short
    # FIXME allow parse_content_as :attributes
    # parse_content_as :attributes
    process do |parent, target|
      doc = parent.document
      attrs = (AttributeList.new target).parse
      valid_key = attrs.keys.find {|key|
        next false unless String === key
        if key.include? '.'
          key.split('.').find {|key_alt| doc.attr? key_alt }
        else
          doc.attr? key
        end
      }
      valid_key ? attrs[valid_key] : ''
    end
  end
end
