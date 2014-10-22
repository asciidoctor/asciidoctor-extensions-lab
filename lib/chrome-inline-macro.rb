require File.join File.dirname(__FILE__), 'chrome-inline-macro/extension'

Extensions.register :uri_schemes do
  inline_macro ChromeUriMacro
end
