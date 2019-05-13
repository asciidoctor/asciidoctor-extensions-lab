require 'prawn'
require 'prawn/forms'
Prawn::Core = PDF::Core

Asciidoctor::Extensions.register do
  block_macro :text_field do
    resolve_attributes 'width=200', 'height=16'
    process do |parent, target, attrs|
      block_attrs = {
        'width' => attrs['width'].to_f,
        'height' => attrs['height'].to_f
      }
      block = create_open_block parent, [], block_attrs
      block.define_singleton_method :convert do
        pdf = self.document.converter
        theme = pdf.instance_variable_get :@theme
        pdf.text_field target, 0, pdf.cursor, (attr 'width'), (attr 'height')
        pdf.move_down (attr 'height') + theme.block_margin_bottom
        nil
      end
      block
    end
  end
end
