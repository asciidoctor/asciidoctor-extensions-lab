# A block macro that passes the contents directly to the output.
#
# Usage
# 
#   docstat:[reading-time]
#
class DocStatInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
  use_dsl

  named :docstat
  name_positional_attributes 'statname'

  def process parent, target, attrs
    case attrs['statname']
      when 'reading-time'
        paragraphs = parent.document.find_by content: :paragraph
        average_word_per_minute = 300
        # TODO Remove markups in order to keep only text content
        word_count = count_word parent.document.source
        word_count / average_word_per_minute
      when 'word-count'
        count_word parent.document.source
    end
  end

  def count_word source
    result = 0
    # TODO Remove markups in order to keep only text content
    source.each_line do |line|
      result += line.split(' ').length
    end
    return result
  end
end
