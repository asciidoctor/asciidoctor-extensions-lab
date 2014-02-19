require File.join File.dirname(__FILE__), File.basename(__FILE__, '.rb'), 'extension'

Extensions.register :uri_schemes do
  inline_macro ManMacro
end
