RUBY_ENGINE == 'opal' ?
  (require 'image-sizing-treeprocessor/extension') :
  (require_relative 'image-sizing-treeprocessor/extension')

Asciidoctor::Extensions.register do
  treeprocessor ImageSizingTreeprocessor
end
