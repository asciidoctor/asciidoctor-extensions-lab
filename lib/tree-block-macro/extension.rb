require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'pathname'

include Asciidoctor

# A block macro that reads the contents of the specified directory
# and renders a decorated tree structure in a listing block.
#
# Usage
#
#   tree::directory[]
#
class TreeBlockMacro < Asciidoctor::Extensions::BlockMacroProcessor
  include_dsl
  named :tree
  def process parent, target, attrs
    target = parent.sub_attributes target
    maxdepth = (attrs.has_key? 'maxdepth') ? attrs['maxdepth'].to_i : nil
    if maxdepth && maxdepth < 1
      warn 'asciidoctor: maxdepth for tree must be greater than 0'
      maxdepth = 1
    end
    levelarg = maxdepth ? %(-L #{maxdepth}) : nil
    sizearg = (attrs.has_key? 'size-option') ? '-sh --du' : nil
    dirarg = (attrs.has_key? 'dir-option') ? '-d' : nil
    # TODO could also output using plantuml
    subs = if sizearg
      [:specialcharacters, :quotes, :macros]
    else
      [:specialcharacters, :macros]
    end
    files_with_sizes = Dir["#{target}/**/*"].map {|f| [f + (File.directory?(f) ? '/' : ''), File.size(f)] }
    lines = files_with_sizes.map do |file, file_size|
      p = Pathname(file)
      final_size = p.directory? ? files_with_sizes.select {|f, s| f.start_with?(file)}.map(&:last).sum : file_size
      size_string = sizearg ? "[.gray]#[#{filesize(final_size)}]#" : ''
      "    " * (p.each_filename.count - 1) + "icon:#{icon(p)} #{p.basename}#{p.directory? ? '/' : ''}"
    end
    #warn tree
    create_listing_block parent, lines.join("\n"), attrs, subs: subs
  end

  private
  def filesize(size)
    units = ['B', 'KiB', 'MiB', 'GiB', 'TiB', 'Pib', 'EiB']

    return '0.0 B' if size == 0
    exp = (Math.log(size) / Math.log(1024)).to_i
    exp = 6 if exp > 6

    '%.1f %s' % [size.to_f / 1024 ** exp, units[exp]]
  end

  def icon(p)
    if p.directory?
      'folder-open[role=lime]'
    elsif p.executable?
      'gears[]'
    elsif p.extname == 'adoc'
      'file-text[role=silver]'
    else
      'file[role=silver]'
    end
  end
end
