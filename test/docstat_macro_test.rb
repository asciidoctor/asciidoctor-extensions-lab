require "asciidoctor"
require "asciidoctor/extensions"
require "test_helper"
require File.expand_path('lib/docstat-macro')

context 'Stats extension' do

  test 'should invoke processor for inline macro' do
    begin
      Asciidoctor::Extensions.register do
        inline_macro DocStatMacro
      end

      output = render_embedded_string 'Word count: docstat::[word-count].'
      assert output.include?('Word count: 3.')

    ensure
      Asciidoctor::Extensions.unregister_all
    end
  end
end


