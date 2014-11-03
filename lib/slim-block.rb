require File.join File.dirname(__FILE__), 'slim-block/extension'

Extensions.register :markup do
  block SlimBlock
end
