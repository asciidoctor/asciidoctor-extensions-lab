RUBY_ENGINE == 'opal' ? (require 'list-of-figures/extension') : (require_relative 'list-of-figures/extension')

Asciidoctor::Extensions.register do
  block_macro ListOfFiguresMacro
  tree_processor ListOfFiguresTreeprocessor
end

