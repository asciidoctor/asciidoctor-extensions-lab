require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
include Asciidoctor

# An inline macro that picks text based on the presence of document-level attributes.
#
# Usage
#
#   pick:[target-web=Web,target-desktop=Desktop]
#   pick:[target-web.target-mobile="Web or mobile",target-desktop=Desktop]
#
#   pick2:target-web,target-mobile@target-desktop[Web or mobile,Desktop]
#
Extensions.register do
  inline_macro :pick do
    using_format :short
    # FIXME allow parse_content_as :attributes
    # parse_content_as :attributes
    process do |parent, target, attrs|
      doc = parent.document
      attrs = (AttributeList.new target).parse if attrs.empty?
      valid_key = attrs.keys.find do |key|
        next false unless String === key
        if key.include? '.'
          key.split('.').find {|key_alt| doc.attr? key_alt }
        else
          doc.attr? key
        end
      end
      valid_key ? (create_inline parent, :quoted, attrs[valid_key]) : nil
    end
  end

  inline_macro :pick2 do
    # FIXME allow parse_content_as :attributes
    # parse_content_as :attributes
    process do |parent, target, attributes|
      doc = parent.document
      valid_key = target.split('@').find_index do |key|
        # TODO implement + to require all keys in list to be set
        if key.include? ','
          key.split(',').find {|key_alt| doc.attr? key_alt }
        else
          doc.attr? key
        end
      end
      valid_key ? (create_inline parent, :quoted, attributes[valid_key + 1]) : nil
    end
  end
end
