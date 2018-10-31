##
# Require this file to register and use the IndirIncludeProcessor.

RUBY_ENGINE == 'opal' ? (require 'indir-include-processor/extension') : (require_relative 'indir-include-processor/extension')

Asciidoctor::Extensions.register do
  include_processor IndirIncludeProcessor
end
