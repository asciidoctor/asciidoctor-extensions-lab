require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Asciidoctor::Extensions.register do
  block_macro TreeBlockMacro
end
