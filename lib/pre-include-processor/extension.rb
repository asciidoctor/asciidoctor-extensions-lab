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
    # NOTE do whatever processing you want to do on the contents
    contents = (File.readlines target, mode: 'r:UTF-8').map {|l| l.sub %r/^# */, '' }.join
    uri = URI::String.new target, contents
    attrlist = attributes.map {|k, v| %(#{k}="#{v}") }.join ','
    reader.unshift %(include::#{target}[#{attrlist}])
    reader.send :preprocess_include_directive, uri, attrlist
    nil
  end

  def handles? target
    !(URI::String === target)
  end
end
