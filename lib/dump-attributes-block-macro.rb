Asciidoctor::Extensions.register do
  # A block macro that dumps the document attributes as attribute entries in a source block.
  #
  # Usage
  #
  #   attributes::[]
  #
  block_macro :attributes do
    process do |parent, target, attrs|
      entries = parent.document.attributes.sort.map do |name, val|
        (val = val.to_s).empty? ? %(:#{name}:) : %(:#{name}: #{val})
      end
      create_listing_block parent, entries, { 'style' => 'source', 'language' => 'asciidoc', 'nowrap-option' => '' }
    end
  end
end
