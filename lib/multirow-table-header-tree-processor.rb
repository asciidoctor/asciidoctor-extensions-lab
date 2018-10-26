Asciidoctor::Extensions.register do
  # A block macro that promotes additional rows from the table body to the
  # table header as specified by the hrows attribute.
  #
  # Usage
  #
  #   [hrows=2]
  #   |===
  #   2+| Inventory
  #
  #   | Name | Quantity | Description
  #
  #   | Bird Seed
  #   | 10
  #   | Lure roadrunners with a tasty treat.
  #   |===
  tree_processor do
    process do |doc|
      (doc.find_by context: :table).each do |table|
        if (hrows = table.attr 'hrows')
          promote_rows = hrows.to_i - (table_rows = table.rows).head.size
          table_rows.head.concat table_rows.body.slice! 0, promote_rows if promote_rows > 0
        end
      end if doc.source.include? 'hrows='
    end
  end
end
