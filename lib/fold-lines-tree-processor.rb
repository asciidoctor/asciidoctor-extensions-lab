Asciidoctor::Extensions.register do
  # Replaces newlines (i.e., line feeds) in paragraphs with a single space.
  tree_processor do
    process do |doc|
      doc.find_by context: :paragraph do |para|
        para.lines = [para.lines * ' ']
      end
    end
  end
end
