require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Extensions.register :markup do
  block SlimBlock
end
