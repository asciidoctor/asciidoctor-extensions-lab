require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# A treeprocessor extension that identifies literal blocks that appear to be
# commands in a shell session and converts them to listing blocks with a
# terminal style.
#
# Usage
#
#   $ gem install asciidoctor
#
class ShellSessionTreeprocessor < Extensions::Treeprocessor
  LF = ?\n

  def process document
    (document.find_by(context: :literal) {|candidate| candidate.lines[0].start_with? '$ ', '> ' }).each do |block|
      (children = block.parent.blocks)[children.index block] = convert_to_terminal_listing block
    end
    nil
  end

  def convert_to_terminal_listing block
    attrs = block.attributes
    attrs['role'] = 'terminal'
    prompt_attr = (attrs.key? 'prompt') ?
        %( data-prompt="#{block.sub_specialchars attrs['prompt']}") : nil
    lines = (block.content.split LF).map do |line|
      if line.start_with? '$ '
        %(<span class="command"#{prompt_attr}>#{line[2..-1]}</span>)
      elsif line.start_with? '&gt; '
        %(<span class="output">#{line[5..-1]}</span>)
        #%(<span class="output"><span class="comment-prefix"># </span>#{line[5..-1]}</span>)
      else
        line
      end
    end
    create_listing_block block.parent, lines * LF, attrs, subs: nil
  end
end
