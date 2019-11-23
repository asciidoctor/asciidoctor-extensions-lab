require 'asciidoctor/extensions'

# An extension that introduces a custom admonition paragraph, complete with
# a custom icon.
class ActionAdmonitionTreeProcessor < Asciidoctor::Extensions::TreeProcessor
  def process doc
    found = nil
    # set the traverse_documents option to look inside AsciiDoc table cells
    doc.find_by context: :paragraph do |para|
      if (lines = para.lines).size > 0 && ((line_1 = lines[0]).start_with? 'ACTION: ')
        found = true
        lines[0] = line_1.slice 7, line_1.length
        para.context = :admonition
        para.set_attr 'name', 'action'
        para.set_attr 'caption', 'Action'
      end
    end
    if found && (doc.basebackend? 'html') && doc.backend != 'pdf'
      '<style>
.admonitionblock td.icon .icon-action:before {content:"\f7ce";color:#0000;}
</style>'
    end
    doc
  end
end
