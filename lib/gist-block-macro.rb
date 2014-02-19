require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Extensions.register do
  if (registry.document.basebackend? 'html') && (registry.document.safe < SafeMode::SECURE)
    block_macro GistBlockMacro
  end
end
