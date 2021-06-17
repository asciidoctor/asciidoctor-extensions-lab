require_relative 'pre-include-processor/extension'

Asciidoctor::Extensions.register do
  include_processor PreIncludeProcessor
end
