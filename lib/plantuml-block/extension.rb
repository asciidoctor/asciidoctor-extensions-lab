require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'securerandom'

include ::Asciidoctor

# An extension that processes the contents of a block
# as a PlantUML using servlet.
#
# Usage
#
#[plantuml]
#----
#
#Bob->Alice : hello
#
#----
#
class PlantumlBlock < Extensions::BlockProcessor
  use_dsl

  named :plantuml
  contexts [:listing, :literal, :open]
  parse_content_as :raw

  def process(parent, reader, attrs)
    content = reader.lines.join('\n')
    id = SecureRandom.uuid

    html = "
    <img id='#{id}' src='' />
    <script>
      var escaped =  unescape(encodeURIComponent('" + content + "'));
      var encodedAndDeflated = encode64(deflate(escaped, 9));
      $('##{id}').attr('src', 'http://www.plantuml.com/plantuml/img/' + encodedAndDeflated);
    </script>"


    create_pass_block parent, html, attrs, subs: nil
  end
end
