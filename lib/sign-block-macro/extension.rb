require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'net/http'
require 'json'

include ::Asciidoctor

class SignBlockMacro < Extensions::BlockMacroProcessor
  use_dsl

  named :sign

  def process parent, target, attributes
    title = (attributes.has_key? 'title') ?
        %(.#{attributes['title']}\n) : ""
    doc = parent.document
    fullkey = doc.attributes['sign-repository'].nil? ? "#{target}.json" : "#{doc.attributes['sign-repository']}/#{target}.json"
    resp = Net::HTTP.get_response(URI.parse(fullkey))
    json_data = JSON.parse(resp.body)
    video_url = json_data['video'].split('/')[-1].split('=')[-1]

    parse_content parent, "#{title}video::#{video_url}[youtube]"
    nil
  end
end
