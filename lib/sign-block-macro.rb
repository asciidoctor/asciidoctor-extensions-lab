RUBY_ENGINE == 'opal' ? (require 'sign-block-macro/extension') : (require_relative 'sign-block-macro/extension')

Asciidoctor::Extensions.register do
  #if @document.basebackend? 'html'
    block_macro SignBlockMacro
  #end
end
