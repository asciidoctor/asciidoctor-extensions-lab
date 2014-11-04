require_relative 'chrome-inline-macro/extension'

Extensions.register :uri_schemes do
  inline_macro ChromeUriMacro
end
