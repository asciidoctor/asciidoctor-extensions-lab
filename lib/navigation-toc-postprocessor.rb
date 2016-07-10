RUBY_ENGINE == 'opal' ? (require 'navigation-toc-postprocessor/extension') : (require_relative 'navigation-toc-postprocessor/extension')

Asciidoctor::Extensions.register do
  if document.basebackend? 'html' # currently only html support
    block NavBlockProcessor
    postprocessor NavigationTocPostprocessor
    docinfo_processor NavIconsDocinfoProcessor
  end
end
