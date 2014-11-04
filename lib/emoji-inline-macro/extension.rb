require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

class EmojifyBlockMacro < Extensions::InlineMacroProcessor
  use_dsl
  named :emoji

  def process parent, target, attributes
    doc = parent.document
    slash = (doc.attr? 'htmlsyntax', 'xml') ? '/' : nil
    size = (attributes.key? 'size') ? attributes['size'] : '24'
    cdn = (attributes.key? 'cdn') ? attributes['cdn'] : 'http://www.tortue.me/emoji/'
    qtarget = %(#{cdn}#{target}.png)
    %(<img src="#{parent.image_uri qtarget, nil}" height="#{size}" width="#{size}"#{slash}>)
  end
end
