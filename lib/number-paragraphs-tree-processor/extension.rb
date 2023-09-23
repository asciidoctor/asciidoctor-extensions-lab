class NumberParagraphsTreeProcessor < Asciidoctor::Extensions::TreeProcessor
  def process document
    para_idx = 0
    (document.find_by {|it| it.context == :section || it.context == :paragraph }).each do |block|
      if block.context == :paragraph
        next if block.lines.empty?
        para_idx += 1
        # uncomment whichever style you prefer
        #add_paragraph_number_to_text block, para_idx
        add_paragraph_number_to_title block, para_idx
      else
        para_idx = 0
      end
    end
  end

  private

  def add_paragraph_number_to_text para, num
    para.lines[0] = %[#{num}) #{para.lines[0]}]
    nil
  end

  def add_paragraph_number_to_title para, num
    para.title = para.title? ? %[#{num}) #{para.instance_variable_get :@title}] : %[#{num})]
    nil
  end
end
