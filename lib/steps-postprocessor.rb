require File.join File.dirname(__FILE__), 'steps-postprocessor/extension'

Asciidoctor::Extensions.register do
  if (@document.basebackend? 'html')
    postprocessor StepsPostprocessor
  end
end
