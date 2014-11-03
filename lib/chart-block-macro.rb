require File.join File.dirname(__FILE__), 'chart-block-macro/extension'

Extensions.register do
  if document.basebackend? 'html'
    block_macro ChartBlockMacro
  end
end
