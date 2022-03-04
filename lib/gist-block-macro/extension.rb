require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# A block macro that embeds a Gist into the output document
#
# Usage
#
#   gist::3fee8a82d319905c81ce99a900a1850d[]
#   gist::https://gist.github.com/mojavelinux/3fee8a82d319905c81ce99a900a1850d[]
#
class GistBlockMacro < Extensions::BlockMacroProcessor
  use_dsl

  named :gist

  def process parent, target, attrs
    role = ((attrs['role'] || '') + ' ').lstrip + 'gist'
    script = %(<script src="https://gist.github.com/#{target.split('/').pop}.js"></script>)
    block = create_open_block parent, [], attrs
    block << (create_pass_block block, script, {})
  end
end
