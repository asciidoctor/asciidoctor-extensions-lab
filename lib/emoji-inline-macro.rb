require_relative 'emoji-inline-macro/extension'

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    inline_macro EmojiBlockMacro
    docinfo_processor TwemojiCssDocinfoProcessor
  end
end
