RUBY_ENGINE == 'opal' ?
  (require 'external-header-attributes-preprocessor/extension') :
  (require_relative 'external-header-attributes-preprocessor/extension')

Asciidoctor::Extensions.register do
  preprocessor ExternalHeaderAttributesPreprocessor
end
