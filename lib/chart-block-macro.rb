require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Extensions.register do
  if document.basebackend? 'html'
    block_macro ChartBlockMacro
  end
end
