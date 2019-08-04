require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

# Mess with these values to your heart's content:

$punct_sntp = '.'         # punctuation between levels' numbers: e.g., '.' yields '1.3.2'
$nr_suffix_sntp = '. '    # punctuation after the number and before the chapter's/section's title
$chap_nums_sntp = true    # enables/disables chapter-labeling--in a book
$part_nums_sntp = true    # enables/disables part-labeling--in a book
$chap_nr_in_sec_nr_sntp = true   # in book, starts sec-labels' nrs with chapter's number (whether or not chap-labeling enabled)
$part_nr_in_chap_nr_sntp = false  # in book, starts chap.-labels' nrs with part's number (whether or not part-labeling enabled)
$part_nr_in_sec_nr_sntp = true # comes into play only if $part_nr_in_chap_nr_sntp = true AND $chap_nr_in_sec_nr_sntp = true
$part_nr_prefix_sntp = 'Part '
$chap_nr_prefix_sntp = 'Chapter '
$appx_nr_prefix_sntp = 'Appendix '
$sec_nr_prefix_sntp = ''
# The style you want at each level (level 0 is PARTS, 1 CHAPS; set styles to 'A','a','I','i', or '1'; add levels if you need to):
$styles_arr_sntp = [ 'I', '1', '1', '1', '1', '1', '1', '1', '1', '1' ]
$styles_appendix_sntp = [ 'I', 'A', '1', '1', '1', '1', '1', '1', '1', '1' ]  # Styles for appendices

# DON'T mess with these values:

$levels_arr_sntp = [ '0', '0', '0', '0', '0', '0', '0', '0', '0', '0' ]
$level_previous_sntp = 0  # pertinent only where someone has, in sequence, (wrongly) jumped two, rather than one level deeper

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
        block.title.replace "#{concat_sec_nr block, levels, dtype}#{block.title}"
        process_blocks block, levels, dtype if block.blocks?
        nil
      end
    end
  end

  def concat_sec_nr block, levels, dtype
    if block.numbered && (defined? block.level) && (!(levels) || block.level.to_i <= levels.to_i)
      styles_arr = ( block.sectname == 'appendix' ? $styles_appendix_sntp : $styles_arr_sntp )
      part_nums = ( block.sectname == 'appendix' ? false : $part_nums_sntp )
      # Just in case levels_arr_sntp needs lengthening for this block:
      if block.level.to_i >= $levels_arr_sntp.length
        for i in ($levels_arr_sntp.length - 1)..block.level.to_i
          $levels_arr_sntp.push '0'
        end
      end
      # Just in case someone has, in sequence, (wrongly) jumped two, rather than one level deeper
      if block.level.to_i > $level_previous_sntp + 1
        for i in ($level_previous_sntp + 1)..(block.level.to_i - 1)
          $levels_arr_sntp[i] = styles_arr[i]
        end
      end
      $level_previous_sntp = block.level.to_i
      # Convert the block.number to the style you specified for this level; and store it in levels_arr_sntp[block.level.to_i] :
      $levels_arr_sntp[block.level.to_i] = convert_block_nr block.number.to_s.tr('A-I', '1-9').to_i, block.level.to_i, styles_arr
      # Apply any appropriate prefix:
      pref = (dtype && dtype == 'book' && block.level.to_i == 1) ? $chap_nr_prefix_sntp : \
          ( (dtype && dtype == 'book' && block.level.to_i == 0) ? $part_nr_prefix_sntp : \
          ( block.level.to_i > 0 ? $sec_nr_prefix_sntp : ''))
      pref = ( block.sectname == 'appendix' ? $appx_nr_prefix_sntp : pref )
      # When doctype='book', must check whether level-1 nrs belong in (the true) sec.nrs--or, level-0 nrs belong in the chap.nrs:
      if (dtype && dtype == 'book')
        if block.level.to_i > 1
          level_to_start = ($chap_nr_in_sec_nr_sntp ? ($part_nr_in_chap_nr_sntp && $part_nr_in_sec_nr_sntp ? 0 : 1 ) : 2)
        elsif block.level.to_i == 1
          level_to_start = ($part_nr_in_chap_nr_sntp ? 0 : 1)
        else
          level_to_start = 0
        end
      else
        level_to_start = 1
      end
      # Compose the number-string:
      str = pref + $levels_arr_sntp[level_to_start]
      for i in (level_to_start + 1)..block.level.to_i
        str += "#{$punct_sntp}#{$levels_arr_sntp[i]}"
      end
      str += $nr_suffix_sntp
      #  When doctype='book', must check whether chap-nrs are enabled--and, whether part-nrs are enabled--and what level ur at:
      dtype && dtype =='book'&& \
         ((block.level.to_i == 1 && !$chap_nums_sntp) || (block.level.to_i == 0 && !part_nums)) ? '' : str
    else
      nil
    end
  end
  
  def convert_block_nr nr, level, styles_arr
    my_char = String.new(styles_arr[level])
    if my_char == 'i' || my_char == 'I'
      big_roman = int_to_roman_str nr
      return (my_char == 'i' ? big_roman.downcase : big_roman)
    else
      for i in 1..(nr - 1)
        my_char.succ!
      end
      return my_char
    end
  end
  
  def int_to_roman_str nr
    # (Thanks, https://codequizzes.wordpress.com/2013/10/27/converting-an-integer-to-a-roman-numeral/ !)
    if nr > 3999 then return 'BLAP!!--NrTooBigForRomanNumFunction:-/' end
    map_of_roman = {
      1000 => "M",
      900 => "CM",
      500 => "D",
      400 => "CD",
      100 => "C",
      90 => "XC",
      50 => "L",
      40 => "XL",
      10 => "X",
      9 => "IX",
      5 => "V",
      4 => "IV",
      1 => "I"
    }
    result = ''

    if nr == 0
      result
    else
      map_of_roman.keys.each do |divisor|
        quotient, modulus = nr.divmod(divisor)
        result << map_of_roman[divisor] * quotient
        nr = modulus
      end
      result
    end
  end
end

