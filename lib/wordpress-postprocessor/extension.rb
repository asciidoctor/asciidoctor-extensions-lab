require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

class WordpressPostprocessor < Asciidoctor::Extensions::Postprocessor

  def process document, output
    # get rid of all <div> and </div> tags including their attributes
    output = output.gsub(/<\/?div(.*?)>/m, "")
    # return copy of output w/ newlines removed
    output.squeeze("\n")
  end 
end
