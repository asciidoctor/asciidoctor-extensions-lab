require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Asciidoctor::Extensions.register do
  if @document.basebackend? 'html'
    inline_macro EmojifyBlockMacro, :emoji
  end
end
