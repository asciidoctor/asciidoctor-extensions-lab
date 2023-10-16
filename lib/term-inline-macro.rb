require 'asciidoctor/extensions' unless defined? Asciidoctor::Extensions

# An inline macro that converts the term and term2 inline macros into a span with the role "terminology"
#
# Usage
#
#   term:[lexer] and term2:parser[]
#
Asciidoctor::Extensions.register do
  inline_macro do
    named :term
    using_format :short

    process do |parent, target, attributes|
      create_inline parent, :quoted, target, attributes: { 'role' => 'terminology' }
    end
  end

  inline_macro do
    named :term2

    process do |parent, target, attributes|
      create_inline parent, :quoted, target, attributes: { 'role' => 'terminology' }
    end
  end
end
