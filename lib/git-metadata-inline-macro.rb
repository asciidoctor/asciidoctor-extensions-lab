RUBY_ENGINE == 'opal' ? (require 'git-metadata-inline-macro/extension') : (require_relative 'git-metadata-inline-macro/extension')

Asciidoctor::Extensions.register do
  inline_macro GitMetadataInlineMacro
end
