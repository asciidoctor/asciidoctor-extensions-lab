RUBY_ENGINE == 'opal' ? (require 'view-result-postprocessor/extension') : (require_relative 'view-result-postprocessor/extension')

Asciidoctor::Extensions.register do
  postprocessor ViewResultPostprocessor if @document.basebackend? 'html'
end
