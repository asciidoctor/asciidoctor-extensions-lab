RUBY_ENGINE == 'opal' ? (require 'navigation-toc-postprocessor/extension') : (require_relative 'navigation-toc-postprocessor/extension')

Asciidoctor::Extensions.register do
  postprocessor NavigationTocPostprocessor
end
