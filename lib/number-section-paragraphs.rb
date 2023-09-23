require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

RUBY_ENGINE == 'opal' ? (require 'number-section-paragraphs/extension') : (require_relative 'number-section-paragraphs/extension')

Asciidoctor::Extensions.register do
  tree_processor NumberSectionParagraphs
end
