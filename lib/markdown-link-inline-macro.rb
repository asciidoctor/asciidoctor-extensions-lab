# An inline macro that parses a Markdown-style link.
#
# Usage
#
#   [Asciidoctor](https://asciidoctor.org)
#
Asciidoctor::Extensions.register do
  inline_macro do
    named :@markdown_link
    match %r/\[(?<content>[^\]]*)\]\((?<target>[^\)]+)\)/
    parse_content_as :text
    process do |parent, target, attrs|
      (create_anchor parent, attrs['text'], type: :link, target: target)
    end
  end
end
