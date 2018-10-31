##
# Asciidoctor extension that adds a variable "indir", pointing at the directory of included asciidoc files.
#
# The indir variable always points at the directory where the current asciidoc file is located.
# The value of the indir variable changes to always reflect the location of the current, included subdocument.
# (Note: This is in contrast to the docfile variable, which remains the same throughout an entire document).
# The indir variable can be used to construct image paths relative to included subdocuments.
#
# Background:
# This extension was created to ease the handling of image paths in nested subdocuments,
# see https://github.com/asciidoctor/asciidoctor/issues/650#issuecomment-433946605.
#
# Motivation:
# The usage scenario that motivates this extension is a nested folder structure with asciidoc files,
# with images stored next to the asciidoc file where they are used.
# For example, an asciidoc file "sub/sub1.adoc" may use an image located at "sub/images/img1.svg".
# In this scenario, we want to be able to compile the asciidoc files in two ways,
# as standalone documents, and included into a parent document.
# The image paths should resolve fine in both cases.
#
# Intended Usage of the Extension:
#
# 1. In the beginning of a subdocument, add this line:
#   ifndef::indir[:indir: .]
#
# 2. Include images like this:
#   image::{indir}/images/example.svg[]
#
# 3. When compiling a master document (that includes other subdocuments), require this extension.
# The extension will set the indir variable to always point at the directory of the included asciidoc file,
# to that the an image path like "{indir}/images/example.svg" is resolved relative to the included subdocument.
#
# Note that the subdocuments compile just fine without the extension.
# This can be handy to use an editor's built-in preview feature.
# The extension is only needed when compiling a master document (that includes other subdocuments).
#
# Caveats, Future Work:
# This extension, once registered, claims to handle any includes
# (because it does not overwrite the "handles?" method of its parent class, which always return true).
# In consequence, it is difficult to use this extension together with other include processor extensions.
# A better solution with finer-grained control could be based on https://github.com/jirutka/asciidoctor-include-ext.
class IndirIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
  def process doc, reader, target, attributes
    content = (open target).readlines

    # Set variables at beginning of the included content
    included_docfile = target
    included_docdir = ::File.dirname target
    content.unshift ''
    content.unshift %(:indir: #{included_docdir})

    # Reset the variables at the end of the included content
    parent_docfile = doc.reader.include_stack&.dig(-1, 1) || (doc.attr 'docfile')
    parent_docdir = ::File.dirname parent_docfile
    content << ''
    content << %(:indir: #{parent_docdir})

    # Push included content for further processing
    reader.push_include content, target, target, 1, attributes
    reader
  end
end
