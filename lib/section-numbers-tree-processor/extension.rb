require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# Mess with these values to your heart's content:

$punct_sntp = '.'         # punctuation between levels' numbers: e.g., '.' yields '1.3.2'
$nr_suffix_sntp = '. '    # punctuation after the number and before the chapter's/section's title
$chap_nums_sntp = true    # enables/disables chapter-labeling
$chap_nr_in_sec_nr_sntp = true   # in book, starts sec-labels' nrs with chapter's number (whether or not chap-labeling enabled)
$chap_nr_prefix_sntp = 'Chapter '
$sec_nr_prefix_sntp = ''
# The style you want at each level (first level is chapters; each level's style must be 'A', 'a', or '1'; add more if you need):
$styles_arr_sntp = [ '1', '1', '1', '1', '1', '1', '1', '1', '1', '1' ]

# DON'T mess with these values:

$levels_arr_sntp = [ '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' ]
$level_previous_sntp = 0  # pertinent only where someone has, in their sequence, wrongly jumped two rather than only one level deeper

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
      if block.level.to_i > $levels_arr_sntp.length
        for i in ($levels_arr_sntp.length)..block.level.to_i
          $levels_arr_sntp.push '0'
        end
      end
      if block.level.to_i > $level_previous_sntp + 1
        for i in ($level_previous_sntp + 1)..block.level.to_i
          $levels_arr_sntp[i - 1] = $styles_arr_sntp[i - 1]
        end
      end
      $level_previous_sntp = block.level.to_i
      $levels_arr_sntp[block.level.to_i - 1] = convert_block_nr block.number, block.level.to_i
      pref = (dtype && dtype == 'book' && block.level.to_i == 1) ? $chap_nr_prefix_sntp : \
          ( block.level.to_i > 0 ? $sec_nr_prefix_sntp : '')
      level_to_start = (dtype && dtype == 'book' && block.level.to_i > 1 && !$chap_nr_in_sec_nr_sntp) ? 2 : 1
      str = pref + $levels_arr_sntp[level_to_start - 1]
      for i in level_to_start..(block.level.to_i - 1)
        str += "#{$punct_sntp}#{$levels_arr_sntp[i]}"
      end
      str += $nr_suffix_sntp
      ($chap_nums_sntp || !dtype || dtype != 'book' || block.level.to_i != 1) ? str : ''
    else
      nil
    end
  end
  
  def convert_block_nr nr, level
    my_char = String.new($styles_arr_sntp[level - 1])
    for i in 1..(nr - 1)
      my_char.succ!
    end
    return my_char
  end
end

