require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

include Asciidoctor

class DataAttrInlineMacro < Extensions::InlineMacroProcessor
  use_dsl
  named :da
  name_positional_attributes 'data'
  
  def process parent, target, attributes
    doc = parent.document
    parent.set_attr target, attributes['data']
    puts parent.attributes
  end
  
end 