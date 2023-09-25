class NumberSectionParagraphs < Asciidoctor::Extensions::TreeProcessor
  def process document
    return unless document.sections?

    document.sections.each_with_index do |section, idx|
      process_section section, idx
    end
  end

  protected

  def add_paragraph_number_to_text paragraph, pnum
    # Mutate paragraph text to include paragraph number
    paragraph.lines.first.prepend %(#{pnum}\)\t)
  end

  def add_paragraph_number_to_title paragraph, pnum
    # Mutate paragraph title to include paragraph number
    # Add a role to allow visual styling when available

    paragraph.title = "%{pnum})%{ws}%{title}" % {
                         pnum:   pnum,
                         ws:     (paragraph.title ? "\t" : ""),
                         title:  paragraph.title }
  end

  def add_paragraph_number_as_sidenote paragraph, pnum
    # Append a paragraph(number) block to the supplied paragraph(content)
    #
    # The intention is to form a structure that mimics the functionality of a LaTeX sidenote.
    #
    # NB 1. This requires Converter support for appropriate rendering
    #       No such converters exist at this stage
    #
    # NB 2. What I want is an :augmentation block context
    #       to convey the relationship with some primary block.
    #
    #       This could be communicated in ASCIIDoc source via an attribute,
    #       eg. an "augments-prior" attribute in a [NOTE] block
    #       takes the meaning of "This [NOTE] explains the prior Block".

    paragraph << Asciidoctor::Block.new(paragraph, :paragraph, {
                  source: %{#pnum},
                  attributes: {
                    roles: 'left-sidenote' }})
  end

  def process_section section, idx
      return unless section.blocks?

      (section.blocks.select {|block| block.context == :paragraph}).each_with_index do |p, idx|
        next if not Asciidoctor::Section === p.parent()

        ###
        # >>> Uncomment the style you prefer or make a style of your own..
        #
        # add_paragraph_number_to_text p, idx + 1
        # add_paragraph_number_as_sidenote p, idx + 1

        add_paragraph_number_to_title p, idx + 1
      end

      return unless section.sections?

      section.sections.each_with_index do |sub_section, idx|
        process_section sub_section, idx
      end
  end
end
