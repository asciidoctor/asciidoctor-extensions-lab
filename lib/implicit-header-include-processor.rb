RUBY_ENGINE == 'opal' ? (require 'implicit-header-include-processor/extension') : (require_relative 'implicit-header-include-processor/extension')

Asciidoctor::Extensions.register do
  include_processor ImplicitHeaderIncludeProcessor
end
