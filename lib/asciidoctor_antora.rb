# This plugin will recongize Antora-style include:: and image::

# NOTE: This is for API demo only. Only basic format with modules is supported. Conversion to ../.. may not work in all cases.

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

class PreIncludeProcessor < Asciidoctor::Extensions::IncludeProcessor
  REGEXP_INCLUDE = /^(.*):(.*)\$(.*)/

  def process doc, reader, target, attributes
    attrlist = attributes.map {|k, v| %(#{k}="#{v}") }.join ','
    target.match(REGEXP_INCLUDE) { |m| target = "../../#{m[1]}/#{m[2]}s/#{m[3]}"}

    reader.unshift %(include::#{target}[#{attrlist}])
    reader.send :preprocess_include_directive, target, attrlist
    nil
  end

  def handles? target
	  target.match? REGEXP_INCLUDE
  end
end

Extensions.register {
  preprocessor {
    REGEXP_IMAGE = /^image::(.*):(.*)/

    process {|document, reader|
      Reader.new reader.readlines.map {|l|
	if (l.match? REGEXP_IMAGE)
          l.match(REGEXP_IMAGE) { |m| %(image::../../#{m[1]}/images/#{m[2]})}
	else
	  l
	end
      }
    }
  }


  include_processor PreIncludeProcessor
} 
