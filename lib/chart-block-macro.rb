RUBY_ENGINE == 'opal' ? (require 'chart-block-macro/extension') : (require_relative 'chart-block-macro/extension')

# see http://www.jsgraphs.com/ for a comparison of JavaScript charting libraries

Extensions.register do
  if document.basebackend? 'html'
    block_macro ChartBlockMacro
    block ChartBlockProcessor
    docinfo_processor ChartAssetsDocinfoProcessor
  end
end
