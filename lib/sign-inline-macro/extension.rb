require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require 'net/http'
require 'json'

include ::Asciidoctor

class SignInlineMacro < Extensions::InlineMacroProcessor
  use_dsl

  named :sign

  def process parent, target, attributes
    doc = parent.document
    fullkey = doc.attributes['sign-repository'].nil? ? "#{target}.json" : "#{doc.attributes['sign-repository']}/#{target}.json"
    resp = Net::HTTP.get_response(URI.parse(fullkey))
    json_data = JSON.parse(resp.body)
    title = json_data['title']
    video_url = json_data['video']
    text = (attributes[1]!=nil) ? attributes[1] : title
    %(#{video_url}["#{text}",role="sign"])
  end
end
