RUBY_ENGINE == 'opal' ? (require 'section-numbers-tree-processor/extension') : (require_relative 'section-numbers-tree-processor/extension')

Asciidoctor::Extensions.register do
  treeprocessor SectionNumbersTreeProcessor
end
