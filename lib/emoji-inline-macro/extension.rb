require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

class EmojiBlockMacro < Extensions::InlineMacroProcessor
  use_dsl
  named :emoji

  SIZE_MAP = {'1x' => 17, 'lg' => 24, '2x' => 34, '3x' => 50, '4x' => 68, '5x' => 85}
  SIZE_MAP.default = 24

  def process parent, target, attributes
    doc = parent.document
    if doc.attributes['emoji'] == 'tortue'
      slash = (doc.attr? 'htmlsyntax', 'xml') ? '/' : nil
      size = SIZE_MAP[attributes['size']]
      cdn = (attributes.key? 'cdn') ? attributes['cdn'] : 'http://www.tortue.me/emoji/'
      qtarget = %(#{cdn}#{target}.png)
      %(<img src="#{parent.image_uri qtarget, nil}" height="#{size}px" width="#{size}px"#{slash}>)
    else
      # By default twemoji
      slash = (doc.attr? 'htmlsyntax', 'xml') ? '/' : nil
      size = (attributes.key? 'size') ? attributes['size'] : nil
      emojiTag = target.tr('_', '-')
      if size == nil
        %(<i class="twa twa-#{emojiTag}"></i>)
      else
        %(<i class="twa twa-#{size} twa-#{emojiTag}"></i>)
      end
    end
  end
end

class TwemojiCssDocinfoProcessor < Extensions::DocinfoProcessor
  use_dsl
  at_location :header

  def process document
    unless document.attributes['emoji'] == 'tortue'
      # Handle data-uri
      %(<link rel="stylesheet" href="#{File.join File.dirname(__FILE__), 'twemoji-awesome.css'}">")
    end
  end
end
