require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Extensions.register :xml_compliance do
  if (@document.basebackend? 'xml') || (@document.attr? 'htmlsyntax', 'xml')
    postprocessor XmlEntityPostprocessor
  end
end
