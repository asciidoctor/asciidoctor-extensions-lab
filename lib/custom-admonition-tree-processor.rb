RUBY_ENGINE == 'opal' ? (require 'custom-admonition-tree-processor/extension') : (require_relative 'custom-admonition-tree-processor/extension')

Asciidoctor::Extensions.register do
  tree_processor ActionAdmonitionTreeProcessor
end
