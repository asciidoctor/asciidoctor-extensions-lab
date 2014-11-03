require File.join File.dirname(__FILE__), 'tree-block-macro/extension'

Asciidoctor::Extensions.register do
  block_macro TreeBlockMacro
end
