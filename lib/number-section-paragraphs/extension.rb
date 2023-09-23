class NumberSectionParagraphs < Asciidoctor::Extensions::TreeProcessor
  def process document
    return unless document.sections?

    document.sections().each_with_index do |section, idx|
      (section.find_by context: :paragraph).each_with_index do |p, idx|
        # Number the paragraph using its title
        # Add a role to allow visual styling when available

        p.title = %(#{idx + 1})
        p.add_role('side-title')
      end
    end
  end
end
