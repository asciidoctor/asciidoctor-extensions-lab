RUBY_ENGINE == 'opal' ? (require 'data-attribute-inline-macro/extension') : (require_relative 'data-attribute-inline-macro/extension')
Asciidoctor::Extensions.register do
    inline_macro DataAttrInlineMacro
end