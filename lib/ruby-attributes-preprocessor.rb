RUBY_ENGINE == 'opal' ?
  (require 'ruby-attributes-preprocessor/extension') :
  (require_relative 'ruby-attributes-preprocessor/extension')

Asciidoctor::Extensions.register do
  preprocessor RubyAttributesPreprocessor
end
