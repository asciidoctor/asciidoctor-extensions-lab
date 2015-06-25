require 'asciidoctor'
require_relative 'extension'

Asciidoctor::Extensions.register do
  treeprocessor LibMathematical
end

Asciidoctor.convert_file('sample.adoc', :in_place => true)
