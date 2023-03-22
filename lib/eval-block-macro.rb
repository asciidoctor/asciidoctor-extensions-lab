# A block macro that evaluates it's contents using Ruby and parses
# the result as an AsciiDoc block.
#
# Usage
#
#    eval::['{name}'.upcase]
#
Asciidoctor::Extensions.register do
  block_macro do
    named :eval
    content_model :text
    process do |parent, target, attrs|
      parse_content parent, (eval parent.apply_subs attrs['text'], [:attributes])
    end
  end
end
