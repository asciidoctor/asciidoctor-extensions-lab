require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# An inline macro that generates links to related man pages.
#
# Usage:
#
#   man:gittutorial[7]
#
class ManInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :man
  name_positional_attributes 'volnum' 

  def process parent, target, attrs
    text = manname = target
    suffix = ''
    target = %(#{manname}.html)
    suffix = if (volnum = attrs['volnum'])
      %((#{volnum}))
    else
      nil
    end
    if parent.document.basebackend? 'html'
      parent.document.register :links, target
      node = create_anchor parent, text, type: :link, target: target
    elsif parent.document.backend == 'manpage'
      node = create_inline parent, :quoted, manname, type: :strong
    else
      node = create_inline parent, :quoted, manname
    end
    create_inline parent, :quoted, %(#{node.convert}#{suffix})
  end
end
