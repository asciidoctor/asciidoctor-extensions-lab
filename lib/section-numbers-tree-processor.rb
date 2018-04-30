RUBY_ENGINE == 'opal' ? (require 'section-numbers-tree-processor/extension') : (require_relative 'section-numbers-tree-processor/extension')

=begin

With this extension, you can control all your chapter- and section-numbering for DocBook output the same way you control it for the HTML5 backend: namely, by using the :sectnums:, :leveloffset:, :sectnumlevels:, and :doctype: attributes.

I would strongly advise that, after using this extension in your to-DocBook conversion, then when using asciidoctor-fopub or (otherwise) a DocBook XSL stylesheet on your XML, you set the XSL stylesheet parameter 'chapter.autolabel' to 0. That will disable the XSL's chapter-numbering, which is superfluous when using this extension.

If using asciidoctor-fopub, I'd set the XSL parameter 'section.autolabel' to 0 also. Here's why, if you're interested:

    In the standard DocBook XSL stylesheets, chapter.autolabel is 1 by default, whereas section.autolabel is 0 by default.
 
    But in asciidoctor-fopub, whether these are 1 or 0 by default DEPENDS, on whether the :sectnums: attribute was unset in your AsciiDoc header metadata:
	
    they default to 1 IF the <?asciidoc-numbered?> XML processing-instruction is present in the DocBook XML file; and 
    that <?asciidoc-numbered?> XML processing-instruction will be present UNLESS :sectnums: was unset in your AsciiDoc document's header metadata.
   
(For how to pass XSL stylesheet parameters when using asciidoctor-fopub, please see https://github.com/asciidoctor/asciidoctor-fopub#custom-xsl-parameters.)
   
Please note that there are several configuration variables at the top of the accompanying extension.rb file, that you can set to control how the extension does the numbering.

=end

Asciidoctor::Extensions.register do
  treeprocessor SectionNumbersTreeProcessor
end
