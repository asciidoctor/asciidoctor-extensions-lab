require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Extensions.register :uri_schemes do
  inline_macro ManMacro
  # Use the following instead for the git man pages
  #inline_macro ManMacro, :linkgit
end
