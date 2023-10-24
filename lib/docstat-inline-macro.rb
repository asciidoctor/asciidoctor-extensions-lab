RUBY_ENGINE == 'opal' ? (require 'docstat-inline-macro/extension') : (require_relative 'docstat-inline-macro/extension')

Asciidoctor::Extensions.register do
  inline_macro DocStatInlineMacro
end
