RUBY_ENGINE == 'opal' ?
  (require 'line-number-treeprocessor/extension') :
  (require_relative 'line-number-treeprocessor/extension')

Asciidoctor::Extensions.register do
  treeprocessor LineNumberTreeprocessor
end
