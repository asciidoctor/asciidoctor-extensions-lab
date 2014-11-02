require 'asciidoctor'
require 'asciidoctor/extensions'
require 'open-uri/cached'
require "base64"


class EmojifyBlockMacro < Asciidoctor::Extensions::InlineMacroProcessor
  def process parent, target, attributes

    puts parent.document.attributes

    size = (attributes.has_key? 'size') ? attributes['size'] : '24'
    cdn = (attributes.has_key? 'cdn') ? attributes['cdn'] : 'http://www.tortue.me/emoji/'

    if(parent.document.attributes.has_key? 'data-uri')
      content = open("#{cdn}#{target}.png") { |io| io.read }
      base64Image = Base64.encode64(content)

      source = %(
        <img height="#{size}" src="data:image/png;base64,#{base64Image}" width="#{size}" />
      )
    else
      source = %(
        <img height="#{size}" src="#{cdn}#{target}.png" width="#{size}" />
      )
    end
  end
end

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    inline_macro EmojifyBlockMacro, :emoji
  end
end
