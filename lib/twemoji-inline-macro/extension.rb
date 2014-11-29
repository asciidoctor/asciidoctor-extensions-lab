require 'open-uri/cached'
require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

class TwemojiBlockMacro < Extensions::InlineMacroProcessor
  use_dsl
  named :twemoji

  def process parent, target, attributes
    doc = parent.document
    slash = (doc.attr? 'htmlsyntax', 'xml') ? '/' : nil
    size = (attributes.key? 'size') ? attributes['size'] : nil
    emojiTag = target.gsub("_", "-")
    if(size == nil)
      %(<i class="twa twa-#{emojiTag}"></i>)
    else
      %(<i class="twa twa-#{size} twa-#{emojiTag}"></i>)
    end
  end
end

class TwemojiCssPostprocessor < Extensions::Postprocessor
  def process document, output
    content = open("https://raw.githubusercontent.com/ellekasai/twemoji-awesome/gh-pages/twemoji-awesome.css") { |io| io.read } //<1>
    replacement = %(<style>
#{content}
</style>)
    output = output.sub(/<\/head>/m, replacement)
  end
end
