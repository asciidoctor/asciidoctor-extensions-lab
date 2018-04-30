require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# Mess with these values to your heart's content:

$punct = '.'
$nr_suffix = '. '
$nr_prefix = ''

# DON'T mess with these values:

$levels_arr = [ '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' ]
$level_previous = 0  # pertinent only where someone has, in their sequence, wrongly jumped two rather than only one level deeper

class SectionNumbersTreeProcessor < Extensions::TreeProcessor
  def process document
    return unless (document.basebackend? 'docbook') && document.blocks?
    process_blocks document
    nil
  end

  def process_blocks node
    node.blocks.each do |block|
      if block.context == :section && (defined? block.title)
        block.title = "#{concat_sec_nr block}#{block.title}"
        process_blocks block if block.blocks?
        nil
      end
    end
  end
  
  def concat_sec_nr block
    if block.numbered && (defined? block.level)
      if block.level.to_i > $level_previous + 1
        for i in ($level_previous + 1)..block.level.to_i
          $levels_arr[i - 1] = '0'
        end
      end
      $level_previous = block.level.to_i
      $levels_arr[block.level.to_i - 1] = block.number.to_s
      str = $nr_prefix + $levels_arr[0]
      for i in 1..(block.level.to_i - 1)
        str += "#{$punct}#{$levels_arr[i]}"
      end
      str += $nr_suffix
    else
      nil
    end
  end
end

