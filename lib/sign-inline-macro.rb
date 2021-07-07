RUBY_ENGINE == 'opal' ? (require 'sign-inline-macro/extension') : (require_relative 'sign-inline-macro/extension')

Asciidoctor::Extensions.register do
  #if @document.basebackend? 'html'
    inline_macro SignInlineMacro
  #end
end
