require File.join File.dirname(__FILE__), 'gist-block-macro/extension'

Extensions.register do
  if (registry.document.basebackend? 'html') && (registry.document.safe < SafeMode::SECURE)
    block_macro GistBlockMacro
  end
end
