require File.join File.dirname(__FILE__), 'xml-entity-postprocessor/extension'

Extensions.register :xml_compliance do
  if (@document.basebackend? 'xml') || (@document.attr? 'htmlsyntax', 'xml')
    postprocessor XmlEntityPostprocessor
  end
end
