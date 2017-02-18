RUBY_ENGINE == 'opal' ? (require 'wordpress-postprocessor/extension') : (require_relative 'wordpress-postprocessor/extension')

# Will generate HTML that is ready to be pasted in the Source view of a wordpress post

Asciidoctor::Extensions.register do
  # Preprocessor marks processed document as embedded
  preprocessor do
    process do |doc, reader|
      # modify document options: set header_footer to false
      doc.instance_variable_set :@options, (doc.options.merge header_footer: false)
      nil
    end
  end

  # Post processor will strip all div tags
  postprocessor WordpressPostprocessor
end
