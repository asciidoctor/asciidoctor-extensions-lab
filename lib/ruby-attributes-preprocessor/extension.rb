require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

class RubyAttributesPreprocessor < Asciidoctor::Extensions::Preprocessor
  def process document, reader
    Object.constants.select {|it| it.to_s.start_with? 'RUBY_' }.each do |name|
      attr_name = ((name.to_s).downcase.gsub '_', '-')
      attr_val = Object.const_get name
      document.set_attr attr_name, attr_val
    end
    nil
  end
end
