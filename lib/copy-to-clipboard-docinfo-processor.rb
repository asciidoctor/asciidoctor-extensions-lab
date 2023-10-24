RUBY_ENGINE == 'opal' ? (require 'copy-to-clipboard-docinfo-processor/extension') : (require_relative 'copy-to-clipboard-docinfo-processor/extension')

Asciidoctor::Extensions.register do
  tree_processor CopyToClipboardTreeProcessor
  docinfo_processor CopyToClipboardStylesDocinfoProcessor
  docinfo_processor CopyToClipboardBehaviorDocinfoProcessor
end
