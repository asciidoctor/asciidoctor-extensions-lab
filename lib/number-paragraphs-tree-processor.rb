require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

RUBY_ENGINE == 'opal' ? (require 'number-paragraphs-tree-processor/extension') : (require_relative 'number-paragraphs-tree-processor/extension')

Asciidoctor::Extensions.register do
  tree_processor NumberParagraphsTreeProcessor
end
