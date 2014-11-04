require_relative 'gist-block-macro/extension'

Extensions.register do
  if (registry.document.basebackend? 'html') && (registry.document.safe < SafeMode::SECURE)
    block_macro GistBlockMacro
  end
end
