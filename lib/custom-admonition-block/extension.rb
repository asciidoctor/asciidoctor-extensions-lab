require 'asciidoctor/extensions'

include Asciidoctor

# An extension that introduces a custom admonition type, complete
# with a custom icon.
#
# Usage
#
#   [QUESTION]
#   ====
#   What's the main tool for selecting colors?
#   ====
#
# or
#
#   [QUESTION]
#   What's the main tool for selecting colors?
#
class CustomAdmonitionBlock < Extensions::BlockProcessor
  use_dsl
  named :QUESTION
  on_contexts :example, :paragraph

  def process parent, reader, attrs
    attrs.update 'name' => 'question', 'textlabel' => 'Question'
    node = create_block parent, :admonition, reader.lines, attrs, content_model: :compound
    node.caption = attrs['textlabel'] unless node.caption
    node
  end
end

class CustomAdmonitionBlockDocinfo < Extensions::DocinfoProcessor
  use_dsl

  def process doc
    if (doc.basebackend? 'html') && doc.backend != 'pdf'
      '<style>
.admonitionblock td.icon .icon-question:before {content:"\f128";color:#871452;}
</style>'
    end
  end
end
