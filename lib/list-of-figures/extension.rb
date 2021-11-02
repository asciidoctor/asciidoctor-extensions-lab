require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
include Asciidoctor

# An macro that adds a list of all figures
# It only uses images that have a caption!
#
# Usage
"""
== Test the List of Figures Macro

.The wonderful linux logo
image::https://upload.wikimedia.org/wikipedia/commons/3/35/Tux.svg[Linux Logo,100,100]

.Another wikipedia SVG image
image::https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SVG_Logo.svg/400px-SVG_Logo.svg.png[SVG,100,100]

=== List of figures

tof::[]
"""
ListOfFiguresMacroPlaceholder = %(9d9711cf-0e95-4230-9973-78559fe928db)

# Replaces tof::[] with ListOfFiguresMacroPlaceholder
class ListOfFiguresMacro < ::Extensions::BlockMacroProcessor
  use_dsl
  named :tof

  def process parent, target, attrs
    create_paragraph parent, ListOfFiguresMacroPlaceholder, {}
  end
end
# Searches for the figures and replaced ListOfFiguresMacroPlaceholder with the list of figures
# Inspired by https://github.com/asciidoctor/asciidoctor-bibtex/blob/master/lib/asciidoctor-bibtex/extensions.rb#L162
class ListOfFiguresTreeprocessor < ::Asciidoctor::Extensions::Treeprocessor
   def process document
       references_asciidoc = []
       document.find_by(context: :image).each do |image|

       if image.caption
           references_asciidoc << %(#{image.caption}#{image.title} +)
        end
      end
      tof_blocks = document.find_by do |b|
        # for fast search (since most searches shall fail)
        (b.content_model == :simple) && (b.lines.size == 1) \
          && (b.lines[0] == ListOfFiguresMacroPlaceholder)
      end
      tof_blocks.each do |block|
        block_index = block.parent.blocks.index do |b|
          b == block
        end
        reference_blocks = parse_asciidoc block.parent, references_asciidoc
        reference_blocks.reverse.each do |b|
          block.parent.blocks.insert block_index, b
        end
        block.parent.blocks.delete_at block_index + reference_blocks.size
      end
    end
    # This is an adapted version of Asciidoctor::Extension::parse_content,
    # where resultant blocks are returned as a list instead of attached to
    # the parent.
    def parse_asciidoc(parent, content, attributes = {})
    result = []
    reader = ::Asciidoctor::Reader.new content
    while reader.has_more_lines?
      block = ::Asciidoctor::Parser.next_block reader, parent, attributes
      result << block if block
    end
    result
    end
  end
