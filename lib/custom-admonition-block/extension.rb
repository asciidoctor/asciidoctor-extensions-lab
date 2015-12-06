require 'asciidoctor/extensions'

include Asciidoctor

# An extension that introduces a custom admonition type, complete
# with a custom icon.
#
# Usage
#
#   [QUESTION]
#   ====
#   How do you know when your code is secure?
#   ====
#
class CustomAdmonitionBlock < Extensions::BlockProcessor
  use_dsl
  named :QUESTION
  on_context :example

  def process parent, reader, attrs
    attrs['name'] = 'question'
    attrs['caption'] = 'Question'
    admon = create_block parent, :admonition, nil, attrs, content_model: :compound
    parse_content admon, reader
    admon
  end
end

class CustomAdmonitionBlockDocinfo < Extensions::DocinfoProcessor
  use_dsl

  def process doc
    '<style>
.admonitionblock td.icon .icon-question:before {content: "\f128";color: #000;}
</style>'
  end
end
