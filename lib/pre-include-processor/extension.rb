require 'tempfile'

class PreIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
  Processed = Module.new

  def process doc, reader, target, attrs
    attrlist = attrs.map {|k, v| %(#{k}="#{v}") }.join ','
    resolved_target, _, _ = reader.send :resolve_include_path, target, attrlist, attrs
    contents = ::File.readlines resolved_target, mode: 'r:UTF-8'
    # ...now do whatever processing you want to do on the contents
    #contents = contents.map {|l| l.sub %r/^# .*/, '' }
    contents = contents.join
    seed = [(File.basename target, '.*'), (File.extname target)]
    ::Tempfile.create seed, (::File.dirname resolved_target), encoding: 'UTF-8', newline: :universal do |tmp_file|
      tmp_target = (File.basename tmp_file.path).extend Processed
      tmp_file.write contents
      tmp_file.close
      reader.unshift %(include::#{tmp_target}[#{attrlist}])
      reader.send :preprocess_include_directive, tmp_target, attrlist
    end
    nil
  end

  def handles? target
    !(Processed === target)
  end
end

=begin
URI.singleton_class.prepend (Module.new do
  def parse url
    return url if URI::Generic === url
    super
  end
end)

class URI::String < URI::HTTP
  def initialize name, contents
    super 'string', nil, 'memory', nil, nil, '/' + name, nil, nil, nil
    @contents = contents
  end

  def buffer_open buf, *rest
    buf << @contents
    buf.io.rewind
    nil
  end

  def include? str
    to_s.include? str
  end

  alias :to_str :to_s
end

# requires -a allow-uri-read to be set
class PreIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
  def process doc, reader, target, attributes
    attrlist = attrs.map {|k, v| %(#{k}="#{v}") }.join ','
    resolved_target, _, _ = reader.send :resolve_include_path, target, attrlist, attrs
    contents = (File.readlines resolved_target, mode: 'r:UTF-8').map {|l| l.sub %r/^# */, '' }.join
    # ...now do whatever other processing you want to do on the contents
    uri = URI::String.new target, contents
    reader.unshift %(include::#{target}[#{attrlist}])
    reader.send :preprocess_include_directive, uri, attrlist
    nil
  end

  def handles? target
    !(URI::String === target)
  end
end
=end
