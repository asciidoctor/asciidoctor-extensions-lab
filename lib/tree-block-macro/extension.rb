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
  FS_UNITS = %w(B K M G T P E)

  use_dsl
  named :tree

  def process parent, target, attrs
    target = parent.sub_attributes target
    maxdepth = (attrs.key? 'maxdepth') && attrs['maxdepth'].to_i
    if maxdepth && maxdepth < 1
      warn 'asciidoctor: maxdepth for tree must be greater than 0'
      maxdepth = 1
    end
    dirs_only = (attrs.key? 'dir-option')
    subs = (show_size = attrs.key? 'size-option') ? [:specialcharacters, :quotes, :macros] : [:specialcharacters, :macros]
    target_pathname = Pathname target
    lines = (walk target_pathname, dirs_only, maxdepth).map do |path|
      filesize = path.directory? ? (calculate_folder_size path) : path.size
      formatted_filesize = show_size ? %([.gray]#[#{format_filesize filesize}]# ) : ''
      indent = '    ' * ((path.instance_variable_get :@depth) - 1)
      %(#{indent}#{icon_for path} #{formatted_filesize}#{path.basename}#{path.directory? ? '/' : ''})
    end
    create_listing_block parent, lines, attrs, subs: subs
  end

  private

  def walk path, dirs_only, maxdepth, depth = 1
    entries = []
    path.children.sort {|a, b| a.basename <=> b.basename }.sort {|a, b| a.directory? ? -1 : (b.directory? ? 1 : 0) }.each do |child|
      child.instance_variable_set :@depth, depth
      if child.directory?
        entries << child
        entries = entries.concat walk child, dirs_only, maxdepth, depth + 1 if !maxdepth || depth < maxdepth
      elsif !dirs_only
        entries << child
      end
    end
    entries
  end

  def calculate_folder_size path
    path.size + (Pathname.glob %(#{path}/**/*)).reduce(0) {|accum, path| accum += path.size }
  end

  def format_filesize size_in_bytes
    return '   0B' if size_in_bytes == 0
    exp = ((Math.log size_in_bytes) / (Math.log 1024)).to_i
    raise %(Unsupported file size: #{size_in_bytes}) if exp > 6
    size = size_in_bytes / 1024.0 ** exp
    if size < 10
      formatted_size = '%4.1f' % [size]
    else
      formatted_size = '%4d' % [size.round]
    end
    %(#{formatted_size}#{FS_UNITS[exp]})
  end

  def icon_for path
    if path.directory?
      'icon:folder-open[role=lime]'
    elsif path.executable?
      'icon:gears[]'
    elsif path.extname == 'adoc'
      'icon:file-text[role=silver]'
    else
      'icon:file[role=silver]'
    end
  end
end
