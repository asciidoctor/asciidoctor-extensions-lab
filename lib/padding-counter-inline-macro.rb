RUBY_ENGINE == 'opal' ? (require 'padding-counter-inline-macro/extension') : (require_relative 'padding-counter-inline-macro/extension')


Asciidoctor::Extensions.register do
	inline_macro PadCounterInlineMacro
	inline_macro PadCounterIncrementInlineMacro
	inline_macro PadCounterDisplayInlineMacro
	inline_macro PadCounterConfigureInlineMacro
end
