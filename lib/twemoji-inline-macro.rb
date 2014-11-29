require_relative 'twemoji-inline-macro/extension'

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    inline_macro TwemojiBlockMacro
    postprocessor TwemojiCssPostprocessor
  end
end
