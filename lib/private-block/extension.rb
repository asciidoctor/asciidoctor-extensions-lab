require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include ::Asciidoctor

# An extension that show or hide private paragraph :
#   shown if attribute is 1
#     else hidden if attribute is 0
#     else shown if document attribute 'show_private' is 1
#     else hidden
#
# Usage
#
#   [private]
#   visibility depends on :show_private: document attribute
#
#   [private,1]
#   private but shown
#
#   [private,0]
#   private and hidden
#

class PrivateBlock < Extensions::BlockProcessor

  use_dsl

  named :private
  on_context :paragraph
  name_positional_attributes 'show'
  parse_content_as :simple

  def process parent, reader, attrs
    show = (attrs.delete 'show') || parent.document.attributes['show_private']
    if show=="1"
      create_paragraph parent, "[private] "+reader.lines.join(" "), attrs
    end
  end
end

