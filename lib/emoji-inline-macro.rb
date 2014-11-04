require_relative 'emoji-inline-macro/extension'

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    inline_macro EmojifyBlockMacro
  end
end
