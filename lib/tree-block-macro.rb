require_relative 'tree-block-macro/extension'

Asciidoctor::Extensions.register do
  block_macro TreeBlockMacro
end
