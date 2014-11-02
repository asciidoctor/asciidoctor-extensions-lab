require File.join File.dirname(__FILE__), 'pass-block-macro/extension'

Extensions.register do
  block_macro PassBlockMacro
end
