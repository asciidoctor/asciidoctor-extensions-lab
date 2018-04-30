RUBY_ENGINE == 'opal' ? (require 'section-numbers-tree-processor/extension') : (require_relative 'section-numbers-tree-processor/extension')

=begin

With this extension, you can control all your chapter- and section-numbering for DocBook output the same way you control it for the HTML5 backend: namely, by using the :sectnums:, :leveloffset:, :sectnumlevels:, and :doctype: attributes.

I would STRONGLY advise, that after using this extension in your to-DocBook conversion, then when using asciidoctor-fopub or (otherwise) a DocBook XSL stylesheet on your XML, set the XSL stylesheet parameter 'chapter.autolabel' to 0. (It is 1 by default--whereas section.autolabel is 0 by default.) That will disable the XSL's chapter-numbering, which is superfluous when using this extension.

Please note that there are several configuration variables at the top of the accompanying extension.rb file, that you can set to control how the extension does the numbering.

=end

Asciidoctor::Extensions.register do
  treeprocessor SectionNumbersTreeProcessor
end
