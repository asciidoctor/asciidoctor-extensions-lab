require File.join File.dirname(__FILE__), 'emoji-inline-macro/extension'

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    inline_macro EmojifyBlockMacro, :emoji
  end
end
