RUBY_ENGINE == 'opal' ? (require 'index-markup-inline-macro/extension') : (require_relative 'index-markup-inline-macro/extension')

Asciidoctor::Extensions.register do
	inline_macro IndexMarkupNoteInlineMacro
	inline_macro IndexMarkupRangeStartInlineMacro
	inline_macro IndexMarkupRangeEndInlineMacro
	block_macro IndexCatalogBlockMacro
end
