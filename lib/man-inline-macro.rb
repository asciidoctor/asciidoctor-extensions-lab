require_relative 'man-inline-macro/extension'

Extensions.register :uri_schemes do
  inline_macro ManMacro
  # Use the following instead for the git man pages
  #inline_macro ManMacro, :linkgit
end
