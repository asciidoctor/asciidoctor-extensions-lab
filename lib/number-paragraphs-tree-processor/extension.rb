class NumberParagraphsTreeProcessor < Asciidoctor::Extensions::TreeProcessor
  def process document
    (document.find_by context: :paragraph).each_with_index do |p, idx|
      pnum = idx + 1
      # number paragraph using title
      #p.title = %(#{pnum}.)

      # or insert number into paragraph
      p.lines.first.prepend %(#{pnum}. )
    end
  end
end
