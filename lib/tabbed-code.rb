RUBY_ENGINE == 'opal' ? (require 'tabbed-code/extension') : (require_relative 'tabbed-code/extension')

Extensions.register :markup do
  docinfo_processor TabbedCode
end
