require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# Mess with these values to your heart's content:

$punct = '.'
$nr_suffix = '. '
$nr_prefix = ''
$chap_nums = false

# DON'T mess with these values:

$levels_arr = [ '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' ]
$level_previous = 0  # pertinent only where someone has, in their sequence, wrongly jumped two rather than only one level deeper

class SectionNumbersTreeProcessor < Extensions::TreeProcessor
  def process document
    return unless (document.basebackend? 'docbook') && document.blocks?
    levels = (defined? document.attributes['sectnumlevels']) ? document.attributes['sectnumlevels'] : nil
    dtype = (defined? document.attributes['doctype']) ? document.attributes['doctype'] : nil
    process_blocks document, levels, dtype
    nil
  end

  def process_blocks node, levels, dtype
    node.blocks.each do |block|
      if block.context == :section && (defined? block.title)
        block.title = "#{concat_sec_nr block, levels, dtype}#{block.title}"
        process_blocks block, levels, dtype if block.blocks?
        nil
      end
    end
  end
  
  def concat_sec_nr block, levels, dtype
    if block.numbered && (defined? block.level) && (!(levels) || block.level.to_i <= levels.to_i)
      if block.level.to_i > $levels_arr.length
        for i in ($levels_arr.length)..block.level.to_i
          $levels_arr.push '0'
        end
      end
      if block.level.to_i > $level_previous + 1
        for i in ($level_previous + 1)..block.level.to_i
          $levels_arr[i - 1] = '1'
        end
      end
      $level_previous = block.level.to_i
      $levels_arr[block.level.to_i - 1] = block.number.to_s
      str = $nr_prefix + $levels_arr[0]
      for i in 1..(block.level.to_i - 1)
        str += "#{$punct}#{$levels_arr[i]}"
      end
      str += $nr_suffix
      if ($chap_nums || !dtype || dtype != 'book' || block.level.to_i > 1)
        str
      else
        ''
      end
    else
      nil
    end
  end
end

